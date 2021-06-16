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