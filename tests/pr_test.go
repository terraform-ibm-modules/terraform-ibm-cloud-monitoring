// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"fmt"
	"math/rand"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"

const fullyconfigurableDADir = "solutions/fully-configurable"
const AccountSettingsDADir = "solutions/metrics-router-account-settings"

var validRegions = []string{
	"au-syd",
	"br-sao",
	"ca-tor",
	"eu-de",
	"eu-gb",
	"jp-osa",
	"jp-tok",
	"us-south",
	"us-east",
}

func TestRunFullyConfigurable(t *testing.T) {
	t.Parallel()

	region := validRegions[rand.Intn(len(validRegions))]
	prefix := "icm-da"

	// Verify ibmcloud_api_key variable is set
	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Region:  region,
		Prefix:  prefix,
		TarIncludePatterns: []string{
			"*.tf",
			"modules/metrics_routing" + "/*.tf",
			fullyconfigurableDADir + "/*.tf",
		},
		TemplateFolder:         fullyconfigurableDADir,
		Tags:                   []string{"icm-da-test"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "cloud_monitoring_resource_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

func TestRunUpgradeFullyConfigurable(t *testing.T) {
	t.Parallel()

	var region = validRegions[rand.Intn(len(validRegions))]
	prefix := fmt.Sprintf("icm-da-up-%s", strings.ToLower(random.UniqueId()))

	// ------------------------------------------------------------------------------------
	// Provision Cloud Monitoring
	// ------------------------------------------------------------------------------------

	var preReqDir = "./existing-resources"
	realTerraformDir := preReqDir
	tempTerraformDir, _ := files.CopyTerraformFolderToTemp(realTerraformDir, prefix)
	tags := common.GetTagsFromTravis()

	// Verify ibmcloud_api_key variable is set
	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")

	logger.Log(t, "Tempdir: ", tempTerraformDir)
	existingTerraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: tempTerraformDir,
		Vars: map[string]interface{}{
			"prefix":        prefix,
			"region":        region,
			"resource_tags": tags,
		},
		// Set Upgrade to true to ensure latest version of providers and modules are used by terratest.
		// This is the same as setting the -upgrade=true flag with terraform.
		Upgrade: true,
	})
	terraform.WorkspaceSelectOrNew(t, existingTerraformOptions, prefix)
	_, existErr := terraform.InitAndApplyE(t, existingTerraformOptions)
	if existErr != nil {
		assert.True(t, existErr == nil, "Init and Apply of pre-req resources failed in TestRunFullyConfigurable test")
	} else {
		// ------------------------------------------------------------------------------------
		// Deploy DA
		// ------------------------------------------------------------------------------------

		options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
			Testing: t,
			Region:  region,
			Prefix:  prefix,
			TarIncludePatterns: []string{
				"*.tf",
				"modules/metrics_routing" + "/*.tf",
				fullyconfigurableDADir + "/*.tf",
			},
			ResourceGroup:          resourceGroup,
			TemplateFolder:         fullyconfigurableDADir,
			Tags:                   []string{"test-schematic"},
			DeleteWorkspaceOnFail:  false,
			WaitJobCompleteMinutes: 60,
		})

		options.TerraformVars = []testschematic.TestSchematicTerraformVar{
			{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
			{Name: "existing_resource_group_name", Value: terraform.Output(t, existingTerraformOptions, "resource_group_name"), DataType: "string"},
			{Name: "existing_cloud_monitoring_crn", Value: terraform.Output(t, existingTerraformOptions, "cloud_monitoring_crn"), DataType: "string"},
			{Name: "region", Value: region, DataType: "string"},
			{Name: "cloud_monitoring_resource_tags", Value: options.Tags, DataType: "list(string)"},
			{Name: "prefix", Value: prefix, DataType: "string"},
		}

		err := options.RunSchematicUpgradeTest()
		assert.Nil(t, err, "This should not have errored")

	}

	// Check if "DO_NOT_DESTROY_ON_FAILURE" is set
	envVal, _ := os.LookupEnv("DO_NOT_DESTROY_ON_FAILURE")
	// Destroy the temporary existing resources if required
	if t.Failed() && strings.ToLower(envVal) == "true" {
		fmt.Println("Terratest failed. Debug the test and delete resources manually.")
	} else {
		logger.Log(t, "START: Destroy (prereq resources)")
		terraform.Destroy(t, existingTerraformOptions)
		terraform.WorkspaceDelete(t, existingTerraformOptions, prefix)
		logger.Log(t, "END: Destroy (prereq resources)")
	}
}

func TestRunAccountSettings(t *testing.T) {
	t.Parallel()

	region := validRegions[rand.Intn(len(validRegions))]
	prefix := "mr"

	// Verify ibmcloud_api_key variable is set
	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")

	permitted_target_regions := []string{"us-south", "eu-de", "us-east", "eu-es", "eu-gb", "au-syd", "br-sao", "ca-tor", "jp-tok", "jp-osa"}

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Region:  region,
		Prefix:  prefix,
		TarIncludePatterns: []string{
			"*.tf",
			"modules/metrics_routing" + "/*.tf",
			AccountSettingsDADir + "/*.tf",
		},
		TemplateFolder:         AccountSettingsDADir,
		Tags:                   []string{"mr-da-test"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "primary_metadata_region", Value: "eu-de", DataType: "string"},
		{Name: "backup_metadata_region", Value: "us-east", DataType: "string"}, // The `backup_metadata_region` should not be same as `primary_metadata_region` so hard-coded the region here
		{Name: "permitted_target_regions", Value: permitted_target_regions, DataType: "list(string)"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}
