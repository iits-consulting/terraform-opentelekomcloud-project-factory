## Create a private DNS for your VPC

Usage Example:

```hcl
module "private_dns" {
  source = "iits-consulting/project-factory/opentelekomcloud//modules/private_dns"
  domain = "my_domain.iits.tech"
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
  vpc_id = var.vpc_id
}
```
Notes:
- This module requires the VPC subnet to use OTC internal DNS servers 100.125.4.25 100.125.129.199 (defaults of OTC).
- Module accepts both subdomain prefixes and full domain names as record keys