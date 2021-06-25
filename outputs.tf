output "vpc" {
  value       = module.vpc
  description = "Information about the created VPC. Please see the VPC module for more information."
}

output "cce" {
  value       = module.cce
  description = "Information about the created CCE cluster. Please see the CCE module for more information."
}

output "loadbalancer" {
  value       = module.loadbalancer
  description = "Information about the created loadbalancer. Please see the loadbalancer module for more information."
}

output "cce_nodes_ssh" {
  value       = module.ssh_keypair.ssh_private_key
  sensitive   = true
  description = "SSH private key for accessing nodes of the created CCE cluster. Please see the CCE module for more information. You might need this for security-relevant updates on the nodes."
}