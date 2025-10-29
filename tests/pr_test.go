// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"math/rand"
	"testing"

	"github.com/stretchr/testify/assert"
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

/*
Common setup options for fully configurable DA variation
*/
func setupOptions(t *testing.T, prefix string) *testschematic.TestSchematicOptions {

	region := validRegions[rand.Intn(len(validRegions))]
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
func TestRunFullyConfigurableUpgrade(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "icm-da-upg")

	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
	}
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
