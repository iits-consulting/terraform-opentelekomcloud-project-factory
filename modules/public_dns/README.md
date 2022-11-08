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
