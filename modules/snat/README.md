## OTC Dedicated Source Network Address Translation (SNAT) Module

A module designed to create a NAT gateway with SNAT rule to allow internet access from VPCs and Subnets

### Usage example

```hcl
// Example VPC setup with 4 subnets
module "vpc" {
  source             = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  cidr_block         = var.vpc_cidr
  name               = "vpc-${var.context_name}-${var.stage_name}"
  // Disable shared SNAT on VPC to use dedicated SNAT
  enable_shared_snat = false
  subnets = {
    "subnet-0" = cidrsubnet(var.vpc_cidr, 2, 0)
    "subnet-1" = cidrsubnet(var.vpc_cidr, 2, 1)
    "subnet-2" = cidrsubnet(var.vpc_cidr, 2, 2)
    "subnet-3" = cidrsubnet(var.vpc_cidr, 2, 3)
  }
}

module "snat" {
  source      = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/snat"
  name_prefix = "${var.context_name}-${var.stage_name}"
  subnet_id   = module.vpc.subnets["subnet-0"].id
  vpc_id      = module.vpc.vpc.id
  // Example to add all subnets but "subnet-2"
  network_ids = [for name, subnet in module.vpc.subnets: subnet.id if name != "subnet-2"]
  // Example to add all subnets
  network_ids = values(module.vpc.subnets)[*].id
}
```

### Notes:

- If no `network_ids` parameter is specified, the module will create the SNAT rule for its own subnet by default 
- It is possible to create CIDR based SNAT rules via `network_cidrs` parameter
