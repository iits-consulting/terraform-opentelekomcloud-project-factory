## Create a private DNS for your VPC

Usage Example:

```hcl
module "pfau_private_dns" {
  source = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  domain = "my_domain.iits.tech"
  a_records = {
    mysql_db     = ["0.1.2.3", "3.4.5.6"]
    postgres     = ["7.8.9.10"]
    google       = ["142.251.36.238"]
    my_subdomain = ["151.101.1.140"]
  }
  aaaa_records = {
    google = ["2a00:1450:4016:80a::200e"]
  }
  vpc_id = var.vpc_id
}
```
