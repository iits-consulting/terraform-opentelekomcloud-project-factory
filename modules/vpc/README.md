##Module to auto create VPC and multiple Subnet

Usage example
```hcl
module "vpc" {
  source                = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version               = "2.0.0-alpha"
  cidr_block = local.vpc_cidr
  name       = "vpc-demo-${local.stage_name}"
  subnets    = {
    "subnet-${local.stage_name}" = "default_cidr"
  }
  tags       = {}
}
```