locals {
  client_key_data                    = opentelekomcloud_cce_cluster_v3.cluster.certificate_users[0].client_key_data
  client_certificate_data            = opentelekomcloud_cce_cluster_v3.cluster.certificate_users[0].client_certificate_data
  kubectl_external_server            = opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[1].server
  cluster_certificate_authority_data = opentelekomcloud_cce_cluster_v3.cluster.certificate_clusters[1].certificate_authority_data
}

locals {
  kubectl_config = yamlencode({
    apiVersion = "v1"
    clusters = [
      {
        cluster = {
          insecure-skip-tls-verify = true
          server                   = local.kubectl_external_server
        }
        name = "cluster-${var.context_name}-${var.stage_name}"
      },
    ]
    contexts = [
      {
        context = {
          cluster = "cluster-${var.context_name}-${var.stage_name}"
          user    = "${var.context_name}-${var.stage_name}"
        }
        name = "${var.context_name}-${var.stage_name}"
      },
    ]
    current-context = "${var.context_name}-${var.stage_name}"
    kind            = "Config"
    preferences     = {}
    users = [
      {
        name = "${var.context_name}-${var.stage_name}"
        user = {
          client-certificate-data = local.client_certificate_data
          client-key-data         = local.client_key_data
        }
      },
    ]
  })
}
