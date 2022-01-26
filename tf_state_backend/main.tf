terraform {
  required_version = "v1.1.4"
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = "1.27.2"
    }
  }
}

provider "opentelekomcloud" {
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
  domain_name = var.project.domain
  tenant_name = var.project.region
}

resource "opentelekomcloud_obs_bucket" "tf_remote_state" {
  bucket     = "${local.context}-tfstate-bucket"
  acl        = "private"
  versioning = true
  server_side_encryption {
    algorithm  = "aws:kms"
    kms_key_id = opentelekomcloud_kms_key_v1.tf_remote_state_bucket_kms_key.id
  }
  tags = local.common_tags
}

resource "opentelekomcloud_kms_key_v1" "tf_remote_state_bucket_kms_key" {
  key_alias       = "${local.context}-tfstate-bucket-key"
  key_description = "${local.context}-tfstate-bucket encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

output "backend_config" {
  value = <<EOT
    backend "s3" {
      bucket = "${opentelekomcloud_obs_bucket.tf_remote_state.bucket}"
      kms_key_id = "arn:aws:kms:eu-de:${opentelekomcloud_kms_key_v1.tf_remote_state_bucket_kms_key.domain_id}:key/${opentelekomcloud_kms_key_v1.tf_remote_state_bucket_kms_key.id}"
      key = "tfstate"
      region = "${opentelekomcloud_obs_bucket.tf_remote_state.region}"
      endpoint = "obs.eu-de.otc.t-systems.com"
      encrypt = true
      skip_region_validation = true
      skip_credentials_validation = true
    }
  EOT
}