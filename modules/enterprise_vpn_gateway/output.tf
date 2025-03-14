output "vpn_gateway" {
  value       = opentelekomcloud_enterprise_vpn_gateway_v5.gateway
  description = "Complete configuration for the created gateway resource."
}

output "vpn_gateway_id" {
  value       = opentelekomcloud_enterprise_vpn_gateway_v5.gateway.id
  description = "UUID of the created gateway resource."
}

output "ip_addresses" {
  value = opentelekomcloud_enterprise_vpn_gateway_v5.gateway.network_type == "public" ? [
    opentelekomcloud_enterprise_vpn_gateway_v5.gateway.eip1[0].ip_address,
    opentelekomcloud_enterprise_vpn_gateway_v5.gateway.eip2[0].ip_address,
    ] : [
    opentelekomcloud_enterprise_vpn_gateway_v5.gateway.access_private_ip_1,
    opentelekomcloud_enterprise_vpn_gateway_v5.gateway.access_private_ip_2,
  ]
  description = "IP addresses of the VPN Gateway. In active-standby mode, the first ip in the list with 0 index is the master IP."
}
