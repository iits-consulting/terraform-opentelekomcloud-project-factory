terraform {
  required_providers {
    opentelekomcloud = {
      source                = "opentelekomcloud/opentelekomcloud"
      configuration_aliases = [opentelekomcloud.project, opentelekomcloud.peer_project]
    }
  }
}
