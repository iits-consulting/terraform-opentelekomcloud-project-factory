output "certificate" {
  value = { for certificate in acme_certificate.certificate : certificate.common_name => {
    certificate = "${certificate.certificate_pem}${certificate.issuer_pem}"
    private_key = certificate.private_key_pem
  } }
  sensitive = true
}