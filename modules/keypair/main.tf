variable "stage_name" {}

resource "tls_private_key" "keypair" {
  algorithm   = "RSA"
  rsa_bits = var.rsa_bits
}

resource "opentelekomcloud_compute_keypair_v2" "keyPairTerraform" {
  name       = "keypair-cce-${var.context}-${var.stage_name}"
  region     = var.region
  public_key = tls_private_key.keypair.public_key_openssh
}

output "keypair_name" {
  value = opentelekomcloud_compute_keypair_v2.keyPairTerraform.name
}