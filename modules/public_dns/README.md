## Manage your domain name records via OTC DNS
Usage Example:

```hcl
module "example-loadbalancer" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/loadbalancer"
  ...
}

module "public_dns" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/public_dns"
  domain = "my-domain.com"
  email  = "my_email@my-domain.com"
  a_records = {
    my-subdomain                  = [module.example-loadbalancer.elb_public_ip]
    "my-domain.com"               = [module.example-loadbalancer.elb_public_ip]
  }
}
```
Notes:
- Valid domain name characters:
```
a-z
A-Z
0-9
- (hyphen)
```
- This module requires the domain registrar to be configured to use OTC DNS servers:
```
ns1.open-telekom-cloud.com
ns2.open-telekom-cloud.com
```
- Module accepts both subdomain prefixes and full domain names as record keys:
```hcl
// Both of these are valid and equivalent for domain = my_domain.com
my-subdomain                 = [<IP_ADDR>]
"my-subdomain.my-domain.com" = [<IP_ADDR>]
```
- For the top level domain, records can be created by referencing it by the full domain name:
```hcl
"my-domain.com" = [<IP_ADDR>]
```
- All records support a list of values as long as it is allowed by the OTC DNS:
```hcl
my_cluster = [<IP_ADDR_1>, <IP_ADDR_2>, ...]
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.31.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.31.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_dns_recordset_v2.a_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.aaaa_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.caa_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.cname_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.mx_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.ns_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.srv_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.txt_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_zone_v2.public_zone](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_zone_v2) | resource |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | Map of DNS A records. Maps domains to IPv4 addresses. | `map(list(string))` | `{}` | no |
| <a name="input_aaaa_records"></a> [aaaa\_records](#input\_aaaa\_records) | Map of DNS AAAA records. Map domains to IPv6 addresses. | `map(list(string))` | `{}` | no |
| <a name="input_caa_records"></a> [caa\_records](#input\_caa\_records) | Map of DNS CAA records. Grant certificate issuing permissions to CAs. | `map(list(string))` | `{}` | no |
| <a name="input_cname_records"></a> [cname\_records](#input\_cname\_records) | Map of DNS CNAME records. Map one domain to another. | `map(list(string))` | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The public domain to create public DNS zone for. | `string` | n/a | yes |
| <a name="input_email"></a> [email](#input\_email) | The email address to create public DNS zone with. | `string` | n/a | yes |
| <a name="input_mx_records"></a> [mx\_records](#input\_mx\_records) | Map of DNS MX records. Map domains to email servers. | `map(list(string))` | `{}` | no |
| <a name="input_ns_records"></a> [ns\_records](#input\_ns\_records) | Map of DNS NS records. Delegate subdomains to other name servers. | `map(list(string))` | `{}` | no |
| <a name="input_srv_records"></a> [srv\_records](#input\_srv\_records) | Map of DNS SRV records. Record servers providing specific services. | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | Map of DNS TXT records. Specify text records. | `map(list(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | n/a |
<!-- END_TF_DOCS -->
