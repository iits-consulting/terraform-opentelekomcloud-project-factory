terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.30.1"
    }
  }
  experiments = [
    module_variable_optional_attrs,
  ]
}
