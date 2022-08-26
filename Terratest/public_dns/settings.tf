terraform {
  required_version = "1.1.7"
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">1.29.5"
    }
  }
}