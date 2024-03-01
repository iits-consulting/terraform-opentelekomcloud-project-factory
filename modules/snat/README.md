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
  
  // Example to add all subnets but "subnet-2".
  // Note that this type of dynamic creation will require a targeted apply on vpc module.  
  network_ids = [for name, subnet in module.vpc.subnets: subnet.id if name != "subnet-2"]
  
  // Example to add all subnets in vpc
  network_cidrs = [var.vpc_cidr]
  }
```

### Notes:

- If no `network_ids` parameter is specified, the module will create the SNAT rule for its own subnet by default 
- It is possible to create CIDR based SNAT rules via `network_cidrs` parameter

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.36.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.36.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_nat_gateway_v2.nat](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/nat_gateway_v2) | resource |
| [opentelekomcloud_nat_snat_rule_v2.snat_cidr](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/nat_snat_rule_v2) | resource |
| [opentelekomcloud_nat_snat_rule_v2.snat_subnet](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/nat_snat_rule_v2) | resource |
| [opentelekomcloud_nat_snat_rule_v2.snat_subnet_default](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/nat_snat_rule_v2) | resource |
| [opentelekomcloud_vpc_eip_v1.nat_ip](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpc_eip_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for all OTC resource names | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Id of the subnet to place SNAT gateway in. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC to create SNAT gateway in. | `string` | n/a | yes |
| <a name="input_nat_bandwidth"></a> [nat\_bandwidth](#input\_nat\_bandwidth) | The dedicated bandwidth assigned to the NAT Gateway. (default: 100) | `string` | `100` | no |
| <a name="input_nat_size"></a> [nat\_size](#input\_nat\_size) | The size of the NAT Gateway. | `string` | `"0"` | no |
| <a name="input_network_cidrs"></a> [network\_cidrs](#input\_network\_cidrs) | List of CIDRs that will use the SNAT gateway. (default: []) | `set(string)` | `[]` | no |
| <a name="input_network_ids"></a> [network\_ids](#input\_network\_ids) | List of subnet that will use the SNAT gateway. (default: var.subnet\_id) | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for OTC resources | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_ip"></a> [nat\_ip](#output\_nat\_ip) | n/a |
<!-- END_TF_DOCS -->
