terraform {
  required_version = "1.3.2"
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">1.29.5"
    }
  }
}