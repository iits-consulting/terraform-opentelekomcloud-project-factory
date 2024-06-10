terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.34.4"
    }
    errorcheck = {
      source = "iits-consulting/errorcheck"
    }
  }
}