terraform {
  required_providers {
    opentelekomcloud = {
      source = "opentelekomcloud/opentelekomcloud"
    }
  }
  experiments = [
    module_variable_optional_attrs,
  ]
}
