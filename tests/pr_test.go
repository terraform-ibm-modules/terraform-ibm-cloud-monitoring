// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"context"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

/*
Global variables
*/
const resourceGroup = "geretain-test-resources"
const terraformVersion = "terraform_v1.12.2" // This should match the version in the ibm_catalog.json
const fullyConfigurableDADir = "solutions/fully-configurable"
const accountSettingsDADir = "solutions/metrics-routing-account-settings"
const existingResourcesDir = "tests/existing-resources"

var tags = []string{"test-schematic", "cloud-monitoring"}
var validRegions = []string{
	"au-syd",
	"br-sao",
	"ca-tor",
	"eu-de",
	"eu-gb",
	"eu-fr2",
	"jp-osa",
	"jp-tok",
	"us-south",
	"us-east",
}

func cleanupTerraform(t *testing.T, options *terraform.Options, prefix string) {
	if t.Failed() && strings.ToLower(os.Getenv("DO_NOT_DESTROY_ON_FAILURE")) == "true" {
		fmt.Println("Terratest failed. Debug the test and delete resources manually.")
		return
	}
	logger.Log(t, "START: Destroy (existing resources)")
	terraform.DestroyContext(t, context.Background(), options)
	terraform.WorkspaceDeleteContext(t, context.Background(), options, prefix)
	logger.Log(t, "END: Destroy (existing resources)")
}

/*
Common setup options for fully configurable DA variation
*/
func setupOptions(t *testing.T, prefix string) *testschematic.TestSchematicOptions {

	region := validRegions[common.CryptoIntn(len(validRegions))]
	plan := "graduated-tier"

	// when region is 'eu-fr2' take opportunity to test 'graduated-tier-sysdig-secure-plus-monitor' plan
	if region == "eu-fr2" {
		plan = "graduated-tier-sysdig-secure-plus-monitor"
	}

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		TarIncludePatterns: []string{
			"*.tf",
			"modules/metrics_routing" + "/*.tf",
			"modules/get_primary_metadata_region" + "/*.tf",
			"modules/get_primary_metadata_region/scripts" + "/*.py",
			fullyConfigurableDADir + "/*.tf",
		},
		TemplateFolder:             fullyConfigurableDADir,
		Prefix:                     prefix,
		Tags:                       tags,
		DeleteWorkspaceOnFail:      false,
		WaitJobCompleteMinutes:     60,
		CheckApplyResultForUpgrade: true,
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				// Have to ignore account settings as other tests may be updating them concurrently
				// which can cause consistency test to fail if not ignored.
				"module.metrics_routing[0].ibm_metrics_router_settings.metrics_router_settings[0]",
			},
		},
		TerraformVersion: terraformVersion,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "existing_resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "cloud_monitoring_resource_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "cloud_monitoring_plan", Value: plan, DataType: "string"},
	}

	return options
}

// Test "Fully configurable" DA variation in schematics
func TestRunFullyConfigurable(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "icm-da")

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

// Upgrade test for "Fully configurable" DA variation in schematics
// This test uses an existing Cloud Monitoring instance to test the path where
// we are not creating a new Cloud Monitoring instance
func TestRunFullyConfigurableUpgrade(t *testing.T) {
	t.Parallel()

	// Provision existing resources first
	prefix := "icm-exist-upg"
	existingTerraformOptions := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  existingResourcesDir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		Region:        validRegions[common.CryptoIntn(len(validRegions))],
	})

	output, err := existingTerraformOptions.RunTestConsistency()
	assert.Nil(t, err, "Existing resources deployment should not have errored")
	assert.NotNil(t, output, "Expected output from existing resources")

	options := setupOptions(t, "icm-da-upg")

	// Add the existing_cloud_monitoring_crn variable to test the upgrade path
	// where we use an existing instance instead of creating a new one
	options.TerraformVars = append(options.TerraformVars, testschematic.TestSchematicTerraformVar{Name: "existing_cloud_monitoring_crn", Value: terraform.OutputContext(t, context.Background(), existingTerraformOptions.TerraformOptions, "cloud_monitoring_crn"), DataType: "string"})

	err = options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
	}

	// Clean up existing resources
	cleanupTerraform(t, existingTerraformOptions.TerraformOptions, prefix)
}

// Test "Metrics Routing account settings" DA variation
// NOTE: No need for upgrade on account settings variation as it doesn't deploy any resources - just metrics account settings
func TestRunAccountSettingsDA(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		TarIncludePatterns: []string{
			"modules/metrics_routing" + "/*.tf",
			accountSettingsDADir + "/*.tf",
		},
		TemplateFolder:         accountSettingsDADir,
		Tags:                   tags,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 30,
		IgnoreUpdates: testhelper.Exemptions{ // Ignore for consistency check
			List: []string{
				"module.metrics_router_account_settings.ibm_metrics_router_settings.metrics_router_settings[0]",
			},
		},
		TerraformVersion: terraformVersion,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "primary_metadata_region", Value: "eu-de", DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}
