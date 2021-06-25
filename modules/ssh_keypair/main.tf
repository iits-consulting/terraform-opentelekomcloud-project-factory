resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "opentelekomcloud_compute_keypair_v2" "ssh_keypair" {
  name       = local.name
  region     = var.region
  public_key = tls_private_key.keypair.public_key_openssh
}