data "opentelekomcloud_identity_project_v3" "current" {
}

locals {
  otc_addon_image_endpoint = data.opentelekomcloud_identity_project_v3.current.region == "eu-de" ? "100.125.7.25:20202" : "swr.eu-nl.otc.t-systems.com"
}

resource "opentelekomcloud_cce_addon_v3" "autoscaler" {
  count            = var.cluster_config.enable_scaling ? 1 : 0
  template_name    = "autoscaler"
  template_version = local.autoscaling_config.version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "cceEndpoint"     = "https://cce.${data.opentelekomcloud_identity_project_v3.current.region}.otc.t-systems.com"
      "ecsEndpoint"     = "https://ecs.${data.opentelekomcloud_identity_project_v3.current.region}.otc.t-systems.com"
      "euleros_version" = "2.2.5"
      "region"          = opentelekomcloud_cce_cluster_v3.cluster.region
      "swr_addr"        = local.otc_addon_image_endpoint
      "swr_user"        = "hwofficial"
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
      "scaleDownUtilizationThreshold"  = local.autoscaling_config.lower_bound
      "scaleUpCpuUtilizationThreshold" = local.autoscaling_config.cpu_upper_bound
      "scaleUpMemUtilizationThreshold" = local.autoscaling_config.mem_upper_bound
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
      "swr_user" = "hwofficial"
    }
    custom = {}
  }
}
