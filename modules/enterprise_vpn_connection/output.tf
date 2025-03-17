output "connection" {
  value       = opentelekomcloud_enterprise_vpn_connection_v5.connection
  sensitive   = true
  description = "Complete configuration for the created connection resources."
}

output "remote_gateway" {
  value       = opentelekomcloud_enterprise_vpn_customer_gateway_v5.remote_gateway
  description = "Complete configuration for the created remote gateway (customer gateway) resources."
}

output "vpn_connection_psk" {
  value       = length(var.psk) > 0 ? var.psk : random_password.vpn_psk[0].result
  sensitive   = true
  description = "PSK used by all created connection resources."
}
