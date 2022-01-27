data "opentelekomcloud_s3_bucket_object" "secrets" {
  bucket = var.bucket_name
  key    = var.bucket_object_key
}

locals {
  imported_secrets = jsondecode(data.opentelekomcloud_s3_bucket_object.secrets.body)
  missing_secrets  = setsubtract(toset(var.required_secrets), toset(keys(local.imported_secrets)))
}

resource "errorcheck_is_valid" "check_secrets" {
  name = "Check if all required secrets are present."
  test = {
    assert        = length(local.missing_secrets) == 0
    error_message = "ERROR! Required secret(s) missing: ${join(", ", local.missing_secrets)} "
  }
}

output "secrets" {
  value     = local.imported_secrets
  sensitive = true
}
