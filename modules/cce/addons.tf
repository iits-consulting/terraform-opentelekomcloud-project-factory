data "opentelekomcloud_cce_addon_templates_v3" "autoscaler" {
  cluster_version = var.cluster_version
  cluster_type    = var.cluster_type
  addon_name      = "autoscaler"
}

resource "errorcheck_is_valid" "autoscaler_version_availability" {
  name = "Check if version selected in var.autoscaler_version is available on OTC."
  test = {
    assert        = var.autoscaler_version == "latest" || contains(data.opentelekomcloud_cce_addon_templates_v3.autoscaler.addons[*].addon_version, var.autoscaler_version)
    error_message = "Please check your autoscaler_version. For CCE ${var.cluster_version} the valid autoscaler versions are: [${join(", ", data.opentelekomcloud_cce_addon_templates_v3.autoscaler.addons[*].addon_version)}]"
  }
}

# OTC API returns the addons in the order of release date, unfortunately this is not always guaranteed to be correctly ordered in terms of semver
# Here is the counter example for the interested reader:
# data "opentelekomcloud_cce_addon_templates_v3" "test" {
#   cluster_version = "v1.27"
#   addon_name      = "autoscaler"
# }
locals {
  autoscaler_split_versions = [for version in data.opentelekomcloud_cce_addon_templates_v3.autoscaler.addons[*].addon_version : split(".", version)]
  autoscaler_major          = max(local.autoscaler_split_versions[*][0]...)
  autoscaler_minor          = max([for version in local.autoscaler_split_versions : version[1] if tonumber(version[0]) == local.autoscaler_major]...)
  autoscaler_patch          = max([for version in local.autoscaler_split_versions : version[2] if tonumber(version[0]) == local.autoscaler_major && tonumber(version[1]) == local.autoscaler_minor]...)
  autoscaler_version        = var.autoscaler_version == "latest" ? "${local.autoscaler_major}.${local.autoscaler_minor}.${local.autoscaler_patch}" : var.autoscaler_version
  autoscaler_template       = [for addon in data.opentelekomcloud_cce_addon_templates_v3.autoscaler.addons : addon if addon.addon_version == local.autoscaler_version][0]
}

locals {
  region_endpoint = replace(local.region, "eu-ch2", "eu-ch2.sc")
}

resource "opentelekomcloud_cce_addon_v3" "autoscaler" {
  count            = var.cluster_enable_scaling ? 1 : 0
  template_name    = data.opentelekomcloud_cce_addon_templates_v3.autoscaler.addon_name
  template_version = local.autoscaler_template.addon_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "cceEndpoint" = "https://cce.${local.region_endpoint}.otc.t-systems.com"
      "ecsEndpoint" = "https://ecs.${local.region_endpoint}.otc.t-systems.com"
      "region"      = opentelekomcloud_cce_cluster_v3.cluster.region
      "swr_addr"    = local.autoscaler_template.swr_addr
      "swr_user"    = local.autoscaler_template.swr_user
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

data "opentelekomcloud_cce_addon_templates_v3" "metrics" {
  cluster_version = var.cluster_version
  cluster_type    = var.cluster_type
  addon_name      = "metrics-server"
}

resource "errorcheck_is_valid" "metrics_version_availability" {
  name = "Check if version selected in var.metrics_server_version is available on OTC."
  test = {
    assert        = var.metrics_server_version == "latest" || contains(data.opentelekomcloud_cce_addon_templates_v3.metrics.addons[*].addon_version, var.metrics_server_version)
    error_message = "Please check your metrics_server_version. For CCE ${var.cluster_version} the valid metrics server versions are: [${join(", ", data.opentelekomcloud_cce_addon_templates_v3.metrics.addons[*].addon_version)}]"
  }
}

# OTC API returns the addons in the order of release date, unfortunately this is not always guaranteed to be correctly ordered in terms of semver
# Here is the counter example for the interested reader:
# data "opentelekomcloud_cce_addon_templates_v3" "test" {
#   cluster_version = "v1.27"
#   addon_name      = "autoscaler"
# }
locals {
  metrics_split_versions = [for version in data.opentelekomcloud_cce_addon_templates_v3.metrics.addons[*].addon_version : split(".", version)]
  metrics_major          = max(local.metrics_split_versions[*][0]...)
  metrics_minor          = max([for version in local.metrics_split_versions : version[1] if tonumber(version[0]) == local.metrics_major]...)
  metrics_patch          = max([for version in local.metrics_split_versions : version[2] if tonumber(version[0]) == local.metrics_major && tonumber(version[1]) == local.metrics_minor]...)
  metrics_version        = var.metrics_server_version == "latest" ? "${local.metrics_major}.${local.metrics_minor}.${local.metrics_patch}" : var.metrics_server_version
  metrics_template       = [for addon in data.opentelekomcloud_cce_addon_templates_v3.metrics.addons : addon if addon.addon_version == local.metrics_version][0]
}

resource "opentelekomcloud_cce_addon_v3" "metrics" {
  template_name    = data.opentelekomcloud_cce_addon_templates_v3.metrics.addon_name
  template_version = local.metrics_template.addon_version
  cluster_id       = opentelekomcloud_cce_cluster_v3.cluster.id

  values {
    basic = {
      "swr_addr" = local.metrics_template.swr_addr
      "swr_user" = local.metrics_template.swr_user
    }
    custom = {}
  }
}
