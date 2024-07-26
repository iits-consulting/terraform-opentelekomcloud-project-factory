terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
      version = ">1.31.5"
    }
  }
}