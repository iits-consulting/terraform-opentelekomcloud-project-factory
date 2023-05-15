## Create a private DNS for your VPC

Usage Example:

```hcl
module "example-vpc" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  ...
}

module "example-db" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/rds"
  ...
}

module "private_dns" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/private_dns"
  vpc_id = module.example-vpc.vpc.id
  domain = "myprivate.endpoints"
  a_records = {
    my_database = [module.example-db.db_private_ip]
  }
}
```
Notes:
- This module requires the VPC subnet to use OTC internal DNS servers 100.125.4.25 100.125.129.199 (defaults of OTC).
- Module accepts both subdomain prefixes and full domain names as record keys:
```hcl
// Both of these are valid and equivalent for domain = myprivate.endpoints
my_database                       = [<IP_ADDR>]
"my_database.myprivate.endpoints" = [<IP_ADDR>]
```
- For the top level domain, records can be created by referencing it by the full domain name:
```hcl
"myprivate.endpoints" = [<IP_ADDR>]
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
| [opentelekomcloud_dns_recordset_v2.cname_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.mx_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.ptr_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.srv_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_recordset_v2.txt_records](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_recordset_v2) | resource |
| [opentelekomcloud_dns_zone_v2.private_zone](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/dns_zone_v2) | resource |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | Map of DNS A records. Maps domains to IPv4 addresses. | `map(list(string))` | `{}` | no |
| <a name="input_aaaa_records"></a> [aaaa\_records](#input\_aaaa\_records) | Map of DNS AAAA records. Map domains to IPv6 addresses. | `map(list(string))` | `{}` | no |
| <a name="input_cname_records"></a> [cname\_records](#input\_cname\_records) | Map of DNS CNAME records. Map one domain to another. | `map(list(string))` | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name to create private DNS zone for. | `string` | n/a | yes |
| <a name="input_mx_records"></a> [mx\_records](#input\_mx\_records) | Map of DNS MX records. Map domains to email servers. | `map(list(string))` | `{}` | no |
| <a name="input_ptr_records"></a> [ptr\_records](#input\_ptr\_records) | Map of DNS SRV records. Map IP addresses to domains. | `map(list(string))` | `{}` | no |
| <a name="input_srv_records"></a> [srv\_records](#input\_srv\_records) | Map of DNS SRV records. Record servers providing specific services. | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | Map of DNS TXT records. Specify text records. | `map(list(string))` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to associate this private DNS zone with. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
