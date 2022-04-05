terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.28.2"
    }
  }
  experiments = [
    module_variable_optional_attrs,
  ]
}
