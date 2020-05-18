//build test
package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSyntaxForIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
	}
	terraform.RunTerraformCommand(t, terraformOptions, terraform.FormatArgs(terraformOptions, "fmt", "--check")...)

}

func TestIntegrationVpc(t *testing.T) {
	t.Parallel()
	region := "eu-west-1"
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		VarFiles:     []string{"variables.tfvars"},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	output_public := terraform.Output(t, terraformOptions, "public_ids")

	aws.IsPublicSubnet(t, output_public, region)

}
