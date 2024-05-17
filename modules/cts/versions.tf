terraform {
  required_providers {
    opentelekomcloud = {
      source                = "opentelekomcloud/opentelekomcloud"
      version               = ">=1.32.0"
      configuration_aliases = [opentelekomcloud.project, opentelekomcloud.top_level_project]
    }
  }
}
