## Create Web Application Firewall for a Domain

Usage Example:

```hcl
module "certificate" {
  source                  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/acme"
  cert_registration_email = "certificates@domain.com"
  otc_domain_name         = var.otc_domain_name
  otc_project_name        = var.project_name
  domains = {
    "domain.com" = ["*.domain.com"]
  }
}

module "waf" {
  source                  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/waf"
  dns_zone_id             = var.dns_zone.id
  domain                  = "subdomain.domain.com"
  certificate             = module.acme_certificate.certificate["domain.com"].certificate
  certificate_private_key = module.acme_certificate.certificate["domain.com"].private_key
  server_addresses = [
    "${var.public_ip}:443",
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.31.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.31.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.certificate_private_key_required](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [errorcheck_is_valid.certificate_private_key_validation](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [errorcheck_is_valid.certificate_required](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [errorcheck_is_valid.certificate_validation](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [opentelekomcloud_dns_recordset_v2.waf](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_waf_certificate_v1.certificate](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/waf_certificate_v1) | resource |
| [opentelekomcloud_waf_domain_v1.domain](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/waf_domain_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | OTC DNS zone to create the WAF CNAME records in. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name to create DNS and WAF resources for. | `string` | n/a | yes |
| <a name="input_server_addresses"></a> [server\_addresses](#input\_server\_addresses) | Set of destination endpoint(s) external IP address(es) and ports they are listening on in format <ip\_addr>:<port> | `set(string)` | n/a | yes |
| <a name="input_certificate"></a> [certificate](#input\_certificate) | Signed certificate in PEM format for the domain(s). | `string` | `""` | no |
| <a name="input_certificate_private_key"></a> [certificate\_private\_key](#input\_certificate\_private\_key) | Private key of the certificate in PEM format for the domain(s). | `string` | `""` | no |
| <a name="input_client_insecure"></a> [client\_insecure](#input\_client\_insecure) | Use HTTP (insecure) protocol between WAF and client. (default: false). | `bool` | `false` | no |
| <a name="input_server_insecure"></a> [server\_insecure](#input\_server\_insecure) | Use HTTP (insecure) protocol between WAF and destination endpoint(s). (default: false). | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for PEGA project resources | `map(string)` | `{}` | no |
| <a name="input_tls_cipher"></a> [tls\_cipher](#input\_tls\_cipher) | Cipher suite to use with TLS. Accepted values are "cipher\_default", "cipher\_1", "cipher\_2" and "cipher\_3". (default: cipher\_1) | `string` | `"cipher_1"` | no |
| <a name="input_tls_version"></a> [tls\_version](#input\_tls\_version) | TLS version to enforce on client. Accepted values are "TLS v1.1" and "TLS v1.2". (default: TLS v1.2) | `string` | `"TLS v1.2"` | no |
| <a name="input_waf_policy_id"></a> [waf\_policy\_id](#input\_waf\_policy\_id) | WAF policy ID to associate with the domains. (default: OTC will create a default policy) | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
