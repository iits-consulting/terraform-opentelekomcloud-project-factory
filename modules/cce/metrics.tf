resource "opentelekomcloud_cce_addon_v3" "metrics" {
  template_name    = "metrics-server"
  template_version = var.addon_metric_server_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
    }
    custom = {}
  }
}
