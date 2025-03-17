output "db_private_ip" {
  value       = opentelekomcloud_rds_instance_v3.db_instance.private_ips[0]
  description = "Private IP address for the database cluster."
}

output "db_public_ip" {
  value       = try(opentelekomcloud_vpc_eip_v1.db_eip[0].publicip[0].ip_address, "")
  description = "Public IP address for the database cluster if var.db_eip_bandwidth is specified. Otherwise empty string \"\"."
}

output "db_root_password" {
  value       = random_password.db_root_password.result
  sensitive   = true
  description = "Root user password for the database cluster."
}

output "db_root_username" {
  value       = opentelekomcloud_rds_instance_v3.db_instance.db[0].user_name
  description = "Root user username for the database cluster."
}

output "sg_secgroup_id" {
  value       = opentelekomcloud_rds_instance_v3.db_instance.security_group_id
  description = "Security group created for the database cluster. This is particularly useful if custom rules outside of the module are desired."
}

output "db_instance_ids" {
  value       = opentelekomcloud_rds_instance_v3.db_instance.nodes[*].id
  description = "Node ECS UUIDs for members of the database cluster."
}

output "db_cluster_id" {
  value       = opentelekomcloud_rds_instance_v3.db_instance.id
  description = "Database cluster UUID."
}

output "db_cluster" {
  sensitive   = true
  value       = opentelekomcloud_rds_instance_v3.db_instance
  description = "Full configuration of the created database cluster, created for flexibility but should not be used if avoidable."
}
