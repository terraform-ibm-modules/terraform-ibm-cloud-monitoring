// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"math/rand"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
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
func TestRunAdvancedExample(t *testing.T) {
	t.Parallel()

	options := setupExamplesOptions(t, "icm-adv", advancedExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
