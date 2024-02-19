terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.35.5"
    }
    errorcheck = {
      source = "iits-consulting/errorcheck"
    }
  }
}
