output "kubectl_config" {
  value = local.kubectl_config
}

output "kubernetes_host" {
  value = local.kubectl_external_server
}

output "kubernetes_ca_cert" {
  value = local.cluster_certificate_authority_data
}

output "endpoint" {
  value = local.kubectl_external_server
}

output "client-certificate" {
  value = local.client_certificate_data
}

output "client-key" {
  value = local.client_key_data
}

output "cluster-ca-certificate" {
  value = local.cluster_certificate_authority_data
}

output "cluster_id" {
  value = opentelekomcloud_cce_cluster_v3.cluster.id
}

output "cluster_name" {
  value = opentelekomcloud_cce_cluster_v3.cluster.name
}