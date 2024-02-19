resource "random_id" "kms_key_unique_suffix" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "remote_state_bucket_kms_key" {
  key_alias       = "${var.tf_state_bucket_name}-key-${random_id.kms_key_unique_suffix.hex}"
  key_description = "${var.tf_state_bucket_name} encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

resource "opentelekomcloud_obs_bucket" "remote_state_bucket" {
  bucket     = var.tf_state_bucket_name
  acl        = "private"
  versioning = true
  server_side_encryption {
    algorithm  = "kms"
    kms_key_id = opentelekomcloud_kms_key_v1.remote_state_bucket_kms_key.id
  }
}

output "terraform_state_backend_config" {
  value = <<EOT
    backend "s3" {
      bucket                      = "${opentelekomcloud_obs_bucket.remote_state_bucket.bucket}"
      key                         = "tfstate"
      region                      = "${opentelekomcloud_obs_bucket.remote_state_bucket.region}"
      endpoint                    = "obs.${data.opentelekomcloud_identity_project_v3.current.region}.otc.t-systems.com"
      skip_region_validation      = true
      skip_credentials_validation = true
    }
  EOT
}
