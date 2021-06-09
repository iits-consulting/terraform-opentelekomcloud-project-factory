variable "stage_name" {
  default     = "dev"
  type        = string
  description = "Utilized to distinguish separate, but mostly equal environments within the same project. Usually dev, test, qa, prod."
}

resource "tls_private_key" "keypair" {
  algorithm   = "RSA"
  rsa_bits = var.rsa_bits
}

resource "opentelekomcloud_compute_keypair_v2" "ssh_keypair" {
  name       = "keypair-cce-${var.context_name}-${var.stage_name}"
  region     = var.region
  public_key = tls_private_key.keypair.public_key_openssh
}

output "keypair_name" {
  value = opentelekomcloud_compute_keypair_v2.ssh_keypair.name
}