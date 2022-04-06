resource "random_id" "id" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "encrypted_cts_key" {
  key_alias       = "${var.bucket_name}-key-${random_id.id.hex}"
  key_description = "${var.bucket_name} encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

data "opentelekomcloud_identity_project_v3" "current" {}

# bucket is required to store tracing logs
resource "opentelekomcloud_obs_bucket" "cloud_tracing_service" {
  bucket        = var.bucket_name
  acl           = "private"
  region        = data.opentelekomcloud_identity_project_v3.current.region
  force_destroy = true
  versioning    = true
  server_side_encryption {
    algorithm  = "aws:kms"
    kms_key_id = opentelekomcloud_kms_key_v1.encrypted_cts_key.id
  }
  lifecycle_rule {
    enabled = true
    name    = "cts-lifecycle"
    expiration {
      days = 180
    }
  }
}

resource "opentelekomcloud_cts_tracker_v1" "cloud_tracing_service_tracker_v1" {
  bucket_name               = var.bucket_name
  file_prefix_name          = var.file_prefix
  status                    = "enabled" # when updating the value can be enabled or disabled.
  is_send_all_key_operation = false     # Required: When the value is TRUE, operations cannot be left empty. Official DOCs are wrong.
  is_support_smn            = false     # "true" allows to notify authoritive users about activity, When the value is false, topic_id and operations can be left empty.
  operations                = []        # Required. Trigger conditions for sending a notification. (we don't send notifications)
  topic_id                  = ""        # Required. The theme of the SMN service.
  project_name              = var.project_name
}
