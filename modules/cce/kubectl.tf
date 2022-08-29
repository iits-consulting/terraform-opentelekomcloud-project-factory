locals {
  client_key_data                    = opentelekomcloud_cce_cluster_v3.cluster.certificate_users[0].client_key_data
  client_certificate_data            = opentelekomcloud_cce_cluster_v3.cluster.certificate_users[0].client_certificate_data
  kubectl_external_server            = try(opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[1].server, "")
  kubectl_internal_server            = opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[0].server
  cluster_certificate_authority_data = opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[0].certificate_authority_data
  kubectl_config_raw = {
    apiVersion = "v1"
    clusters = [
      {
        cluster = {
          server                     = local.kubectl_external_server
          certificate-authority-data = local.cluster_certificate_authority_data
        }
        name = "${var.name}-cluster"
      },
      {
        cluster = {
          insecure-skip-tls-verify = true
          server                   = local.kubectl_external_server
        }
        name = "${var.name}-cluster-insecure"
      },
      {
        cluster = {
          server                     = local.kubectl_internal_server
          certificate-authority-data = local.cluster_certificate_authority_data
        }
        name = "${var.name}-cluster-internal"
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
      {
        context = {
          cluster = "${var.name}-cluster-internal"
          user    = "terraform"
        }
        name = "${var.name}-internal"
      },
    ]
    current-context = var.name
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
  kubectl_config_raw_internal = {
    apiVersion = "v1"
    clusters = [
      {
        cluster = {
          server                     = local.kubectl_internal_server
          certificate-authority-data = local.cluster_certificate_authority_data
        }
        name = "${var.name}-cluster"
      },
      {
        cluster = {
          insecure-skip-tls-verify = true
          server                   = local.kubectl_internal_server
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
    current-context = var.name
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
  kubectl_config_yaml = local.cluster_config.cluster_is_public ? yamlencode(local.kubectl_config_raw) : yamlencode(local.kubectl_config_raw_internal)
  kubectl_config_json = local.cluster_config.cluster_is_public ? jsonencode(local.kubectl_config_raw) : jsonencode(local.kubectl_config_raw_internal)
}
