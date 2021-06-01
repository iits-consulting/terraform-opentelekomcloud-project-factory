variable "stage_name" {}

resource "tls_private_key" "keypair" {
  algorithm   = "RSA"
  rsa_bits = 2048
}

resource "opentelekomcloud_compute_keypair_v2" "keyPairTerraform" {
  name       = "keypair-${var.stage_name}"
  region     = "eu-de"
  public_key = tls_private_key.keypair.public_key_openssh
}

output "keypair_name" {
  value = opentelekomcloud_compute_keypair_v2.keyPairTerraform.name
}