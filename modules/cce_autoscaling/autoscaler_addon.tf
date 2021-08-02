resource "opentelekomcloud_cce_addon_v3" "autoscaler" {
  template_name    = "autoscaler"
  template_version = var.autoscaler_version
  cluster_id       = var.cce.id

  values {
    basic = {
      "cceEndpoint" : "https://cce.eu-de.otc.t-systems.com",
      "ecsEndpoint" : "https://ecs.eu-de.otc.t-systems.com",
      "euleros_version" : "2.2.5",
      "region" : var.cce.region,
      "swr_addr" : "100.125.7.25:20202",
      "swr_user" : "hwofficial"
    }
    custom = {
      "cluster_id" : var.cce.id,
      "tenant_id" : var.project_id,
      "coresTotal" : 1000,
      "maxEmptyBulkDeleteFlag" : 11,
      "maxNodesTotal" : 100,
      "memoryTotal" : 64000,
      "scaleDownDelayAfterAdd" : 15,
      "scaleDownDelayAfterDelete" : 15,
      "scaleDownDelayAfterFailure" : 3,
      "scaleDownEnabled" : true,
      "scaleDownUnneededTime" : 7,
      "scaleDownUtilizationThreshold" : 0.23,
      "scaleUpCpuUtilizationThreshold" : 0.8,
      "scaleUpMemUtilizationThreshold" : 0.8,
      "scaleUpUnscheduledPodEnabled" : true,
      "scaleUpUtilizationEnabled" : true,
      "unremovableNodeRecheckTimeout" : 7
    }
  }
}


