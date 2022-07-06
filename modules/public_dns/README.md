## Manage your domain name records via OTC DNS

Usage Example:

```hcl
module "public_dns" {
  source = "iits-consulting/project-factory/opentelekomcloud//modules/public_dns"
  domain = "my_domain.iits.tech"
  email  = "my_email@my_domain.iits.tech"
  a_records = {
    mysql_db                            = ["0.1.2.3", "3.4.5.6"]
    postgres                            = ["7.8.9.10"]
    google                              = ["142.251.36.238"]
    my_subdomain                        = ["151.101.1.140"]
    "my_domain.iits.tech"               = ["127.0.0.1"]
    "fullsubdomain.my_domain.iits.tech" = ["8.8.8.8"]
  }
  aaaa_records = {
    google = ["2a00:1450:4016:80a::200e"]
  }
}
```
Notes:
- This module requires the domain registrar to be configured to use OTC DNS servers:
```
ns1.open-telekom-cloud.com
ns2.open-telekom-cloud.com
```
- Module accepts both subdomain prefixes and full domain names as record keys