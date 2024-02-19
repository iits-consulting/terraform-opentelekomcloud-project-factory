variable "tf_state_bucket_name" {
  type        = string
  description = "Bucket name."
}

data "opentelekomcloud_identity_project_v3" "current" {}

resource "errorcheck_is_valid" "provider_project_constraint" {
  name = "Check if the provider is correctly set to top level project."
  test = {
    assert        = data.opentelekomcloud_identity_project_v3.current.name == data.opentelekomcloud_identity_project_v3.current.region
    error_message = "ERROR! This module requires the provider project (tenant_name) to be a region level project. See README.md for more information."
  }
}