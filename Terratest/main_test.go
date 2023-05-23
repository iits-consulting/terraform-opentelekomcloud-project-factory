package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestNetworkSetup(t *testing.T) {
	context := "network"
	performTerratest(t, context)
}

func TestCCE(t *testing.T) {
	context := "cce"
	performTerratest(t, context)
}

func TestOBSRestricted(t *testing.T) {
	context := "obs_restricted"
	if os.Getenv("TF_VAR_region") == "eu-de" {
		performTerratest(t, context)
	} else {
		fmt.Println("Skipping Test OBSRestricted for Region ", os.Getenv("TF_VAR_region"))
	}
	performTerratest(t, context)
}

func TestPublicDNS(t *testing.T) {
	context := "public_dns"
	if os.Getenv("TF_VAR_region") == "eu-de" {
		performTerratest(t, context)
	} else {
		fmt.Println("Skipping Test PublicDNS for Region", os.Getenv("TF_VAR_region"))
	}
}

//FIXME Currently not working
//func TestRDS(t *testing.T) {
//	context := "rds"
//	performTerratest(t, context)
//}

//FIXME Currently not working
//func TestWAF(t *testing.T) {
//	context := "waf"
//	performTerratest(t, context)
//}

func performTerratest(t *testing.T, context string) {
	os.Setenv("TF_VAR_context", context)

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
