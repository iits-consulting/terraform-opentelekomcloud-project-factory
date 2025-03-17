terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.36.31"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
