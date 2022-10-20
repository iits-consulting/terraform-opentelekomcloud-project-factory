data "opentelekomcloud_identity_project_v3" "current" {
}

locals {
  current_region           = data.opentelekomcloud_identity_project_v3.current.region
  region_endpoint          = local.current_region == "eu-ch2" ? "${local.current_region}.sc" : local.current_region
  otc_addon_image_endpoint = "swr.${local.region_endpoint}.otc.t-systems.com"
  swr_user                 = "cce-addons"
}

resource "opentelekomcloud_cce_addon_v3" "autoscaler" {
  count            = var.cluster_config_enable_scaling ? 1 : 0
  template_name    = "autoscaler"
  template_version = var.autoscaling_config.version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "cceEndpoint" = "https://cce.${local.region_endpoint}.otc.t-systems.com"
      "ecsEndpoint" = "https://ecs.${local.region_endpoint}.otc.t-systems.com"
      "region"      = opentelekomcloud_cce_cluster_v3.cluster.region
      "swr_addr"    = local.otc_addon_image_endpoint
      "swr_user"    = local.swr_user
    }
    custom = {
      "cluster_id"                     = opentelekomcloud_cce_cluster_v3.cluster.id
      "tenant_id"                      = data.opentelekomcloud_identity_project_v3.current.id
      "coresTotal"                     = 16000
      "expander"                       = "priority"
      "logLevel"                       = 4
      "maxEmptyBulkDeleteFlag"         = 11
      "maxNodesTotal"                  = 100
      "memoryTotal"                    = 64000
      "scaleDownDelayAfterAdd"         = 15
      "scaleDownDelayAfterDelete"      = 15
      "scaleDownDelayAfterFailure"     = 3
      "scaleDownEnabled"               = true
      "scaleDownUnneededTime"          = 7
      "scaleDownUtilizationThreshold"  = var.autoscaling_config.lower_bound
      "scaleUpCpuUtilizationThreshold" = var.autoscaling_config.cpu_upper_bound
      "scaleUpMemUtilizationThreshold" = var.autoscaling_config.mem_upper_bound
      "scaleUpUnscheduledPodEnabled"   = true
      "scaleUpUtilizationEnabled"      = true
      "unremovableNodeRecheckTimeout"  = 7
    }
  }
}

resource "opentelekomcloud_cce_addon_v3" "metrics" {
  template_name    = "metrics-server"
  template_version = var.metrics_server_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "swr_addr" = local.otc_addon_image_endpoint
      "swr_user" = local.swr_user
    }
    custom = {}
  }
}
