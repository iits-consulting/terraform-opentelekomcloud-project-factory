package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestModule(t *testing.T) {
	context := os.Getenv("TF_VAR_context")
	performTerratest(t, context)
}

func performTerratest(t *testing.T, context string) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: context,
	})

	defer destroyTwice(t, terraformOptions)
	initAndApplyTwice(t, terraformOptions)
}

func destroyTwice(t *testing.T, options *terraform.Options) {
	if _, err := terraform.DestroyE(t, options); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR Destroy failed try again")
		terraform.Destroy(t, options)
	}
}

func initAndApplyTwice(t *testing.T, terraformOptions *terraform.Options) {
	if _, err := terraform.InitAndApplyE(t, terraformOptions); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR Apply failed try again")
		terraform.InitAndApply(t, terraformOptions)
	}
}
