//bui
package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSyntaxForUnit(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
	}
	terraform.RunTerraformCommand(t, terraformOptions, terraform.FormatArgs(terraformOptions, "fmt", "--check")...)

}
func TestUnitVpc(t *testing.T) {
	t.Parallel()
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		VarFiles:     []string{"variables.tfvars"},
	}

	defer terraform.Destroy(t, terraformOptions)

	output := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, output, "Plan:")
}
