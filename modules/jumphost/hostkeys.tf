resource "tls_private_key" "host_key_rsa" {
  count     = var.preserve_host_keys ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "host_key_ecdsa" {
  count       = var.preserve_host_keys ? 1 : 0
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_private_key" "host_key_ed25519" {
  count     = var.preserve_host_keys ? 1 : 0
  algorithm = "ED25519"
}

locals {
  cloud_init_host_keys = try(yamlencode({
    ssh_keys = {
      rsa_private     = tls_private_key.host_key_rsa[0].private_key_pem
      rsa_public      = tls_private_key.host_key_rsa[0].public_key_openssh
      ecdsa_private   = tls_private_key.host_key_ecdsa[0].private_key_pem
      ecdsa_public    = tls_private_key.host_key_ecdsa[0].public_key_openssh
      ed25519_private = tls_private_key.host_key_ed25519[0].private_key_pem
      ed25519_public  = tls_private_key.host_key_ed25519[0].public_key_openssh
    }
  }), "")
}
