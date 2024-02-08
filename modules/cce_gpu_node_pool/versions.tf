terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.32.0"
    }
    errorcheck = {
      source = "iits-consulting/errorcheck"
    }
  }
}
