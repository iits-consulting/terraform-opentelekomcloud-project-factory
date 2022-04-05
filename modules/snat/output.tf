output "nat_ip" {
  value = opentelekomcloud_vpc_eip_v1.nat_ip.publicip[0].ip_address
}

