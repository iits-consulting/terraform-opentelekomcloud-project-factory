resource "random_id" "id" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "encrypted_secrets_key" {
  key_alias       = "${var.bucket_name}-key-${random_id.id.hex}"
  key_description = "x${var.bucket_name} encryption key"
  pending_days    = 7
  is_enabled      = "true"
  realm           = var.region
}

resource "opentelekomcloud_obs_bucket" "secrets" {
  bucket     = var.bucket_name
  acl        = "private"
  versioning = true
  tags       = var.tags
  region     = var.region
  server_side_encryption {
    algorithm  = "aws:kms"
    kms_key_id = opentelekomcloud_kms_key_v1.encrypted_secrets_key.id
  }
}

resource "opentelekomcloud_obs_bucket_object" "secrets" {
  key          = var.bucket_object_name
  encryption   = true
  content      = jsonencode(var.secrets)
  content_type = "application/json"
  bucket       = opentelekomcloud_obs_bucket.secrets.bucket
  kms_key_id   = opentelekomcloud_kms_key_v1.encrypted_secrets_key.id
}