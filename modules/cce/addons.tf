data "opentelekomcloud_cce_addon_template_v3" "autoscaler" {
  count         = var.cluster_enable_scaling ? 1 : 0
  addon_version = var.autoscaler_version
  addon_name    = "autoscaler"
}

locals {
  region_endpoint = replace(local.region, "eu-ch2", "eu-ch2.sc")
}

resource "opentelekomcloud_cce_addon_v3" "autoscaler" {
  count            = var.cluster_enable_scaling ? 1 : 0
  template_name    = data.opentelekomcloud_cce_addon_template_v3.autoscaler[0].addon_name
  template_version = data.opentelekomcloud_cce_addon_template_v3.autoscaler[0].addon_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "cceEndpoint" = "https://cce.${local.region_endpoint}.otc.t-systems.com"
      "ecsEndpoint" = "https://ecs.${local.region_endpoint}.otc.t-systems.com"
      "region"      = opentelekomcloud_cce_cluster_v3.cluster.region
      "swr_addr"    = data.opentelekomcloud_cce_addon_template_v3.autoscaler[0].swr_addr
      "swr_user"    = data.opentelekomcloud_cce_addon_template_v3.autoscaler[0].swr_user
    }
    custom = {
      "cluster_id"                    = opentelekomcloud_cce_cluster_v3.cluster.id
      "tenant_id"                     = data.opentelekomcloud_identity_project_v3.current.id
      "coresTotal"                    = 16000
      "expander"                      = "priority"
      "logLevel"                      = 4
      "maxEmptyBulkDeleteFlag"        = 11
      "maxNodesTotal"                 = 100
      "memoryTotal"                   = 64000
      "scaleDownDelayAfterAdd"        = 15
      "scaleDownDelayAfterDelete"     = 15
      "scaleDownDelayAfterFailure"    = 3
      "scaleDownEnabled"              = true
      "scaleDownUnneededTime"         = 7
      "scaleUpUnscheduledPodEnabled"  = true
      "scaleUpUtilizationEnabled"     = true
      "unremovableNodeRecheckTimeout" = 7
    }
  }
}

data "opentelekomcloud_cce_addon_template_v3" "metrics" {
  addon_version = var.metrics_server_version
  addon_name    = "metrics-server"
}

resource "opentelekomcloud_cce_addon_v3" "metrics" {
  template_name    = data.opentelekomcloud_cce_addon_template_v3.metrics.addon_name
  template_version = data.opentelekomcloud_cce_addon_template_v3.metrics.addon_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "swr_addr" = data.opentelekomcloud_cce_addon_template_v3.metrics.swr_addr
      "swr_user" = data.opentelekomcloud_cce_addon_template_v3.metrics.swr_user
    }
    custom = {}
  }
}
