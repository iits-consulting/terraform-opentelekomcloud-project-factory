data "opentelekomcloud_identity_project_v3" "current" {}

# bucket is required to store tracing logs
resource "opentelekomcloud_obs_bucket" "cloud_tracing_service" {
  bucket        = var.bucket_name
  acl           = "private"
  region        = data.opentelekomcloud_identity_project_v3.current.region
  force_destroy = true
  versioning    = true
  lifecycle_rule {
    enabled = true
    name    = "cts-lifecycle"
    expiration {
      days = var.cts_expiration_days
    }
  }
}

resource "opentelekomcloud_cts_tracker_v1" "cloud_tracing_service_tracker_v1" {
  bucket_name               = opentelekomcloud_obs_bucket.cloud_tracing_service.bucket
  file_prefix_name          = var.file_prefix
  status                    = "enabled" # when updating the value can be enabled or disabled.
  is_send_all_key_operation = false     # Required: When the value is TRUE, operations cannot be left empty. Official DOCs are wrong.
  is_support_smn            = false     # "true" allows to notify authoritive users about activity, When the value is false, topic_id and operations can be left empty.
  project_name              = var.project_name
  lifecycle {
    ignore_changes = [project_name] // This is to prevent deletion of the tracker as OTC seems to not record this parameter
  }
}
