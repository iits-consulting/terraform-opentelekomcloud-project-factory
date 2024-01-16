data "opentelekomcloud_identity_project_v3" "current" {}

resource "errorcheck_is_valid" "provider_project_constraint" {
  name = "Check if the provider is not eu-nl."
  test = {
    assert        = data.opentelekomcloud_identity_project_v3.current.region != "eu-nl"
    error_message = "ERROR! This module can not run with eu-nl since the api only works for eu-de. Just switch the region for the provider it will work for eu-de and eu-nl."
  }
}