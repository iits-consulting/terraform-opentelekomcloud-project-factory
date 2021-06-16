resource "opentelekomcloud_kms_key_v1" "s3_kms_key" {
  key_alias       = "${var.bucket_name}-key"
  key_description = "${var.bucket_name}-key"
  pending_days    = var.pending_days
  realm           = var.region
  is_enabled      = "true"
  lifecycle {
    ignore_changes = [
      key_description,
      pending_days,
      is_enabled,
    realm]
  }
}

resource "opentelekomcloud_obs_bucket" "tf_remote_state" {
  bucket     = var.bucket_name
  acl        = "private"
  region     = var.region
  tags       = var.tags
  versioning = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "opentelekomcloud_obs_bucket_policy" "only_encrypted" {
  bucket = opentelekomcloud_obs_bucket.tf_remote_state.id
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "EnforceEncryption"
        Effect = "Deny"
        Principal = {
          "AWS" : [
          "*"]
        }
        Action = [
        "s3:PutObject"],
        Resource = [
        "arn:aws:s3:::${opentelekomcloud_obs_bucket.tf_remote_state.bucket}/*"]
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = [
            "aws:kms"]
          }
        }
      }
    ]
  })
}