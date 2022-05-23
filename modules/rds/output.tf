output "db_private_ip" {
  value = opentelekomcloud_rds_instance_v3.db_instance.private_ips[0]
}

output "db_public_ip" {
  value = try(opentelekomcloud_vpc_eip_v1.db_eip[0].publicip[0].ip_address, "")
}

output "db_root_password" {
  value     = random_password.db_root_password.result
  sensitive = true
}

output "db_root_username" {
  value = opentelekomcloud_rds_instance_v3.db_instance.db[0].user_name
}

output "sg_secgroup_id" {
  value = opentelekomcloud_rds_instance_v3.db_instance.security_group_id
}

output "db_instance_ids" {
  value = opentelekomcloud_rds_instance_v3.db_instance.nodes[*].id
}
