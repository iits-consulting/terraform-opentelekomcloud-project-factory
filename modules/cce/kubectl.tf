locals {
  client_key_data                    = opentelekomcloud_cce_cluster_v3.cluster.certificate_users[0].client_key_data
  client_certificate_data            = opentelekomcloud_cce_cluster_v3.cluster.certificate_users[0].client_certificate_data
  kubectl_external_server            = try(opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[1].server, "")
  kubectl_internal_server            = opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[0].server
  cluster_certificate_authority_data = opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[0].certificate_authority_data

  kubectl_config_raw_internal = {
    clusters = [
      {
        cluster = {
          insecure-skip-tls-verify   = false
          server                     = local.kubectl_internal_server
          certificate-authority-data = local.cluster_certificate_authority_data
        }
        name = "${var.name}-cluster-internal"
      },
      {
        cluster = {
          insecure-skip-tls-verify   = true
          server                     = local.kubectl_internal_server
          certificate-authority-data = ""
        }
        name = "${var.name}-cluster-insecure-internal"
      },
    ]
    contexts = [
      {
        context = {
          cluster = "${var.name}-cluster-internal"
          user    = "terraform"
        }
        name = "${var.name}-internal"
      },
      {
        context = {
          cluster = "${var.name}-cluster-insecure-internal"
          user    = "terraform"
        }
        name = "${var.name}-insecure-internal"
      },
    ]
  }
  kubectl_config_raw_external = {
    clusters = [
      {
        cluster = {
          insecure-skip-tls-verify   = false
          server                     = local.kubectl_external_server
          certificate-authority-data = local.cluster_certificate_authority_data
        }
        name = "${var.name}-cluster"
      },
      {
        cluster = {
          insecure-skip-tls-verify   = true
          server                     = local.kubectl_external_server
          certificate-authority-data = ""
        }
        name = "${var.name}-cluster-insecure"
      },
    ]
    contexts = [
      {
        context = {
          cluster = "${var.name}-cluster"
          user    = "terraform"
        }
        name = var.name
      },
      {
        context = {
          cluster = "${var.name}-cluster-insecure"
          user    = "terraform"
        }
        name = "${var.name}-insecure"
      },
    ]
  }
  kubectl_config_raw = {
    apiVersion      = "v1"
    clusters        = var.cluster_public_access ? concat(local.kubectl_config_raw_external.clusters, local.kubectl_config_raw_internal.clusters) : local.kubectl_config_raw_internal.clusters
    contexts        = var.cluster_public_access ? concat(local.kubectl_config_raw_external.contexts, local.kubectl_config_raw_internal.contexts) : local.kubectl_config_raw_internal.contexts
    current-context = var.cluster_public_access ? var.name : "${var.name}-internal"
    kind            = "Config"
    preferences     = {}
    users = [
      {
        name = "terraform"
        user = {
          client-certificate-data = local.client_certificate_data
          client-key-data         = local.client_key_data
        }
      },
    ]
  }
  kubectl_config_yaml = yamlencode(local.kubectl_config_raw)
  kubectl_config_json = jsonencode(local.kubectl_config_raw)
}
