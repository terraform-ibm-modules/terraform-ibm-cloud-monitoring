// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"math/rand"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// Ensure every example directory has a corresponding test
const advancedExampleDir = "examples/advanced"
const basicExampleDir = "examples/basic"

func setupExamplesOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		Region:        validRegions[rand.Intn(len(validRegions))],
	})

	return options
}

// Consistency test for the basic example
func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupExamplesOptions(t, "icm-basic", basicExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// Consistency test for the advanced example
// NOTE: It is run in Schematics because the example configures a CBR rule to only allow traffic from schematics zone
func TestRunAdvancedExampleInSchematics(t *testing.T) {
	t.Parallel()

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  "icm-adv",
		Region:  validRegions[rand.Intn(len(validRegions))],
		TarIncludePatterns: []string{
			"*.tf",
			"modules/metrics_routing" + "/*.tf",
			advancedExampleDir + "/*.tf",
		},
		ResourceGroup:          resourceGroup,
		TemplateFolder:         advancedExampleDir,
		Tags:                   tags,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "region", Value: options.Region, DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}
