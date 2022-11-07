terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.31.5"
    }
    errorcheck = {
      source = "iits-consulting/errorcheck"
    }
  }
}
