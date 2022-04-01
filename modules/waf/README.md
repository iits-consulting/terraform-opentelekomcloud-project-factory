## Create Web Application Firewall for a Domain

Usage Example:

```hcl
module "certificate" {
  source                  = "iits-consulting/project-factory/opentelekomcloud//modules/acme"
  cert_registration_email = "certificates@domain.com"
  otc_domain_name         = var.otc_domain_name
  otc_project_name        = var.project_name
  domains = {
    "domain.com" = ["*.domain.com"]
  }
}

module "waf" {
  source                  = "iits-consulting/project-factory/opentelekomcloud//modules/waf"
  dns_zone_id             = var.dns_zone.id
  domain                  = "subdomain.domain.com"
  certificate             = module.acme_certificate.certificate["domain.com"].certificate
  certificate_private_key = module.acme_certificate.certificate["domain.com"].private_key
  server_addresses = [
    "${var.public_ip}:443",
  ]
}
```

Notes:
- This module requires OTC Terraform Provider version 1.28.2 or newer.