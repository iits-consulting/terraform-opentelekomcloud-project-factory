resource "random_id" "bucket_kms_key_id" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "bucket_kms_key" {
  key_alias       = "${var.bucket_name}-key-${random_id.bucket_kms_key_id.hex}"
  key_description = "${var.bucket_name} encryption key"
  pending_days    = 7
  is_enabled      = "true"
  tags            = var.tags
}

resource "opentelekomcloud_obs_bucket" "bucket" {
  bucket     = var.bucket_name
  acl        = "private"
  versioning = var.enable_versioning
  server_side_encryption {
    algorithm  = "kms"
    kms_key_id = opentelekomcloud_kms_key_v1.bucket_kms_key.id
  }
  tags = var.tags
}
