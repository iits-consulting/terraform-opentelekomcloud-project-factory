# bucket is required to store tracing logs
resource "opentelekomcloud_s3_bucket" "cloud_tracing_service" {
  bucket        = var.bucket_name
  acl           = "private"
  region        = var.region
  force_destroy = true
  versioning {
    enabled = false
  }
  lifecycle_rule {
    enabled = true
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
