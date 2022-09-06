terraform {
  required_version = "1.1.7"
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">1.29.5"
    }
    acme = {
      source = "vancluever/acme"
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}