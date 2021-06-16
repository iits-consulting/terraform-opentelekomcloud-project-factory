output "backend_config" {
  value = <<EOT
    backend "s3" {
      key = "tfstate"
      bucket = "${var.bucket_name}"
      region = "${var.region}"
      endpoint = "obs.eu-de.otc.t-systems.com"
      skip_region_validation = true
      skip_credentials_validation = true
      encrypt = true
      kms_key_id = "arn:aws:kms:eu-de:${opentelekomcloud_kms_key_v1.s3_kms_key.domain_id}:key/${opentelekomcloud_kms_key_v1.s3_kms_key.id}"
    }
  EOT
}