terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.31.7"
    }
    errorcheck = {
      source = "iits-consulting/errorcheck"
    }
  }
}
