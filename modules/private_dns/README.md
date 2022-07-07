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
  source = "iits-consulting/project-factory/opentelekomcloud//modules/private_dns"
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