terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.28.2"
    }
    errorcheck = {
      source = "rhythmictech/errorcheck"
    }
  }
}
