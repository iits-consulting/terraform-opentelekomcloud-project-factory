## Dedicated Loadbalancer

A module designed to create and manage a dedicated ELB instance with private and public IP.

Usage example:
```
module "vpc" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version    = "6.0.2"
  name       = "${var.context}-${var.stage}-vpc"
  cidr_block = var.vpc_cidr
  subnets = {
    "dmz-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
  }
  tags = local.tags
}

module "loadbalancer" {
  source             = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/dedicated_loadbalancer"
  version            = "6.0.2"
  availability_zones = var.availability_zones
  name_prefix        = "${var.context}-${var.stage}"
  subnet_id          = module.vpc.subnets["dmz-subnet"].subnet_id
  network_ids        = [module.vpc.subnets["dmz-subnet"].network_id]
  tags               = local.tags
}
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
| [opentelekomcloud_lb_loadbalancer_v3.elb](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/lb_loadbalancer_v3) | resource |
| [opentelekomcloud_vpc_eip_v1.ingress_eip](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpc_eip_v1) | resource |
| [opentelekomcloud_lb_flavor_v3.layer4_flavor](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/lb_flavor_v3) | data source |
| [opentelekomcloud_lb_flavor_v3.layer7_flavor](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/lb_flavor_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones for the ELB instance. | `set(string)` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Common prefix for all OTC resource names | `string` | n/a | yes |
| <a name="input_network_ids"></a> [network\_ids](#input\_network\_ids) | Network IDs to use for loadbalancer backends. Default: <obtained from subnet\_id> | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet where the elastic load balancer will be created. | `string` | n/a | yes |
| <a name="input_bandwidth"></a> [bandwidth](#input\_bandwidth) | The bandwidth size. The value ranges from 1 to 1000 Mbit/s. | `number` | `100` | no |
| <a name="input_layer4_flavor"></a> [layer4\_flavor](#input\_layer4\_flavor) | Flavor string for layer 4 routing. Default: L4\_flavor.elb.s1.small (set to "" explicitly to disable layer 4.) | `string` | `"L4_flavor.elb.s1.small"` | no |
| <a name="input_layer7_flavor"></a> [layer7\_flavor](#input\_layer7\_flavor) | Flavor string for layer 7 routing. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elb_id"></a> [elb\_id](#output\_elb\_id) | n/a |
| <a name="output_elb_private_ip"></a> [elb\_private\_ip](#output\_elb\_private\_ip) | n/a |
| <a name="output_elb_public_ip"></a> [elb\_public\_ip](#output\_elb\_public\_ip) | n/a |
<!-- END_TF_DOCS -->