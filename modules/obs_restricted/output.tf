output "bucket_name" {
  value = var.bucket_name
}

output "bucket_access_key" {
  value = opentelekomcloud_identity_credential_v3.user_aksk.access
}

output "bucket_secret_key" {
  value = opentelekomcloud_identity_credential_v3.user_aksk.secret
}
