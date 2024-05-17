terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
    }
  }
}
