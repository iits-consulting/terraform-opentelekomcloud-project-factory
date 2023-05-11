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
  bucket_name      = opentelekomcloud_obs_bucket.cloud_tracing_service.bucket
  file_prefix_name = var.file_prefix
  is_lts_enabled   = var.enable_trace_analysis
}
