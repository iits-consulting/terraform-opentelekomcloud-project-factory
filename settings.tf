terraform {
  required_version = "v0.14.8"
  backend "s3" {
    key = "tfstate"
    bucket = var.tf_remote_state_bucket_name
    region = var.region
    endpoint = var.tf_remote_state_bucket_endpoint
    skip_region_validation = true
    skip_credentials_validation = true
    encrypt = true
    kms_key_id = var.kms_key_id
  }
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = "1.23.11"
    }
  }
}