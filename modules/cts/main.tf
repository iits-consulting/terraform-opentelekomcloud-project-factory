resource "random_id" "id" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "cloud_tracing_service_key" {
  provider        = opentelekomcloud.top_level_project
  key_alias       = "${var.bucket_name}-key-${random_id.id.hex}"
  key_description = "${var.bucket_name} encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

resource "opentelekomcloud_obs_bucket" "cloud_tracing_service" {
  provider      = opentelekomcloud.top_level_project
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true
  versioning    = false
  server_side_encryption {
    algorithm  = "kms"
    kms_key_id = opentelekomcloud_kms_key_v1.cloud_tracing_service_key.id
  }
  lifecycle_rule {
    enabled = true
    name    = "cts-lifecycle"
    expiration {
      days = var.cts_expiration_days
    }
  }
  tags = var.tags
}

resource "opentelekomcloud_cts_tracker_v3" "cloud_tracing_service_tracker" {
  provider         = opentelekomcloud.project
  bucket_name      = opentelekomcloud_obs_bucket.cloud_tracing_service.bucket
  file_prefix_name = var.file_prefix
  is_lts_enabled   = var.enable_trace_analysis
  status           = "enabled"
}
