terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.24.3"
      # provider version 1.24.1 and 1.24.2 have a bug that prevents the node pool from creation.
    }
  }

}
