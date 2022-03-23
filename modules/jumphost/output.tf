output "jumphost_sg_id" {
  value = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id
}

output "jumphost_address" {
  value = opentelekomcloud_vpc_eip_v1.jumphost_eip.publicip[0].ip_address
}
