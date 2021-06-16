output "kubectl_config" {
  value = local.kubectl_config
}

output "kubernetes_ca_cert" {
  value = local.cluster_certificate_authority_data
}

output "kube_api_endpoint" {
  value = local.kubectl_external_server
}

output "client-certificate" {
  value = local.client_certificate_data
}

output "client-key" {
  value = local.client_key_data
}

output "cce_id" {
  value = opentelekomcloud_cce_cluster_v3.cluster.id
}

output "cce_name" {
  value = opentelekomcloud_cce_cluster_v3.cluster.name
}