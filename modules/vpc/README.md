##Module to auto create VPC and multiple Subnet

Usage example
```hcl
module "vpc" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version    = "2.0.0-alpha"
  name       = "vpc-demo-${local.stage_name}"
  cidr_block = "10.0.0.0/16"
  subnets = {                                 
    "kubernetes-subnet" = cidrsubnet(var.cidr_block, 2, 0)
    "database-subnet"   = cidrsubnet(var.cidr_block, 3, 2)
    "jumphost-subnet"   = cidrsubnet(var.cidr_block, 3, 3)
  }
}
```
> **WARNING:** using defaults for `cidr_block` and `subnets` is not recommended!
> 
> These parameters define network address ranges (CIDR) and must be chosen based on requirements.
> Changing them at a future point will cause the network to be recreated, destroying any resource within!