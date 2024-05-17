data "opentelekomcloud_cce_addon_template_v3" "gpu" {
  count         = var.gpu_beta_enabled ? 1 : 0
  addon_version = var.gpu_beta_version
  addon_name    = "gpu-beta"
}

resource "opentelekomcloud_cce_addon_v3" "gpu" {
  count            = var.gpu_beta_enabled ? 1 : 0
  template_name    = data.opentelekomcloud_cce_addon_template_v3.gpu[0].addon_name
  template_version = data.opentelekomcloud_cce_addon_template_v3.gpu[0].addon_version
  cluster_id       = var.cce_cluster_id

  values {
    basic = {
      "swr_addr" = data.opentelekomcloud_cce_addon_template_v3.gpu[0].swr_addr
      "swr_user" = data.opentelekomcloud_cce_addon_template_v3.gpu[0].swr_user
    }
    custom = {
      is_driver_from_nvidia      = true
      nvidia_driver_download_url = var.gpu_driver_url
    }
  }
}
