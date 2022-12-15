# This has nothing to do with lb (loadbalancer) it is kept for backwards compatibility
output "cluster_lb_public_ip" {
  value = local.kubectl_external_server
}

output "cluster_public_ip" {
  value = local.kubectl_external_server
}

output "cluster_private_ip" {
  value = local.kubectl_internal_server
}

output "node_pool_ids" {
  value = { for node_pool in opentelekomcloud_cce_node_pool_v3.cluster_node_pool : node_pool.name => node_pool.id }
}

output "node_pool_keypair_name" {
  value = opentelekomcloud_compute_keypair_v2.cluster_keypair.name
}

output "node_pool_keypair_private_key" {
  sensitive = true
  value     = tls_private_key.cluster_keypair.private_key_openssh
}

output "node_pool_keypair_public_key" {
  sensitive = true
  value     = tls_private_key.cluster_keypair.public_key_openssh
}

output "cluster_credentials" {
  value = {
    kubectl_config                     = local.kubectl_config_yaml
    client_key_data                    = local.client_key_data
    client_certificate_data            = local.client_certificate_data
    kubectl_external_server            = local.kubectl_external_server
    kubectl_internal_server            = local.kubectl_internal_server
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

output "node_sg_id" {
  value = opentelekomcloud_cce_cluster_v3.cluster.security_group_node
}
