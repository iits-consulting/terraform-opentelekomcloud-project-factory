output "keypair_name" {
  value = opentelekomcloud_compute_keypair_v2.ssh_keypair.name
}

output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.keypair.private_key_pem
}