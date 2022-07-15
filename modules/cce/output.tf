output "cluster_lb_public_ip" {
  value = opentelekomcloud_vpc_eip_v1.cce_eip.publicip[0].ip_address
}

output "node_pool_id" {
  value = opentelekomcloud_cce_node_pool_v3.cluster_node_pool.id
}

output "cluster_credentials" {
  value = {
    kubectl_config                     = local.kubectl_config_yaml
    client_key_data                    = local.client_key_data
    client_certificate_data            = local.client_certificate_data
    kubectl_external_server            = local.kubectl_external_server
    cluster_certificate_authority_data = local.cluster_certificate_authority_data
  }
}

output "cluster_id" {
  value = opentelekomcloud_cce_cluster_v3.cluster.id
}

output "cluster_name" {
  value = opentelekomcloud_cce_cluster_v3.cluster.name
}

output "kubeconfig" {
  value = local.kubectl_config_yaml
}

output "kubeconfig_yaml" {
  value = local.kubectl_config_yaml
}

output "kubeconfig_json" {
  value = local.kubectl_config_json
}
