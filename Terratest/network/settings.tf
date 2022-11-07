terraform {
  required_version = "1.3.3"
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">1.31.5"
    }
  }
}