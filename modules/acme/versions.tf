terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.35.5"
    }
    acme = {
      source = "vancluever/acme"
    }
  }
}
