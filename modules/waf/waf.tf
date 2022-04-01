resource "opentelekomcloud_waf_certificate_v1" "certificate" {
  count   = var.client_insecure ? 0 : 1
  name    = replace(var.domain, ".", "_")
  content = var.certificate
  key     = var.certificate_private_key
  lifecycle {
    create_before_destroy = true
  }
}

resource "opentelekomcloud_waf_domain_v1" "domain" {
  hostname = var.domain
  dynamic "server" {
    for_each = var.server_addresses
    content {
      client_protocol = var.client_insecure ? "HTTP" : "HTTPS"
      server_protocol = var.server_insecure ? "HTTP" : "HTTPS"
      address         = split(":", server.key)[0]
      port            = split(":", server.key)[1]
    }
  }
  tls            = var.server_insecure ? null : var.tls_version
  cipher         = var.server_insecure ? null : var.tls_cipher
  policy_id      = var.waf_policy_id
  certificate_id = var.client_insecure ? null : opentelekomcloud_waf_certificate_v1.certificate[0].id
  proxy          = false
}

resource "opentelekomcloud_dns_recordset_v2" "waf" {
  zone_id     = var.dns_zone_id
  name        = var.domain
  description = "CNAME for ${var.domain} WAF."
  ttl         = 3000
  type        = "CNAME"
  records     = ["${opentelekomcloud_waf_domain_v1.domain.cname}."]
}
