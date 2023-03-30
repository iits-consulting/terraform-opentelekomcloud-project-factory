resource "random_id" "id" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "encrypted_secrets_key" {
  key_alias       = "${var.bucket_name}-key-${random_id.id.hex}"
  key_description = "${var.bucket_name} encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

resource "opentelekomcloud_obs_bucket" "secrets" {
  count      = var.create_bucket ? 1 : 0
  bucket     = var.bucket_name
  acl        = "private"
  versioning = var.enable_versioning
  tags       = var.tags
  server_side_encryption {
    algorithm  = "kms"
    kms_key_id = opentelekomcloud_kms_key_v1.encrypted_secrets_key.id
  }
}

resource "opentelekomcloud_obs_bucket_object" "secrets" {
  key          = var.bucket_object_key
  encryption   = true
  content      = jsonencode(var.secrets)
  content_type = "application/json"
  bucket       = opentelekomcloud_obs_bucket.secrets[0].bucket
  kms_key_id   = opentelekomcloud_kms_key_v1.encrypted_secrets_key.id
}