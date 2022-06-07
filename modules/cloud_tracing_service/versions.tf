terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.29.0"
      configuration_aliases = [ opentelekomcloud.top_level, opentelekomcloud.subproject ]
    }
  }

}
