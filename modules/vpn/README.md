# VPN Module

A module designed to create a vpn tunnel. 

Usage example:
```hcl
module "vpc" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  name   = "${var.context}-${var.stage}-vpc"

  cidr_block = var.vpc_cidr
  subnets    = {
    "vpn-subnet" = "175.1.2.0/24"
  }
  tags       = local.tags
}

resource "random_password" "vpn_psk" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

module "vpn_tunnel" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpn"
  name   = "${var.context}-${var.stage}-vpn"

  psk            = random_password.vpn_psk.result
  dpd            = var.vpn_dpd
  remote_gateway = "180.12.12.0"
  remote_subnets = ["170.10.1.0/24"]
  local_router   = module.vpc.vpc.id
  local_subnets  = values(module.vpc.subnets).*.cidr

  vpn_ike_policy_dh_algorithm         = var.vpn_ike_policy_dh_algorithm
  vpn_ike_policy_auth_algorithm       = var.vpn_ike_policy_auth_algorithm
  vpn_ike_policy_encryption_algorithm = var.vpn_ike_policy_encryption_algorithm
  vpn_ike_policy_lifetime             = var.vpn_ike_policy_lifetime

  vpn_ipsec_policy_protocol             = var.vpn_ipsec_policy_protocol
  vpn_ipsec_policy_auth_algorithm       = var.vpn_ipsec_policy_auth_algorithm
  vpn_ipsec_policy_encryption_algorithm = var.vpn_ipsec_policy_encryption_algorithm
  vpn_ipsec_policy_lifetime             = var.vpn_ipsec_policy_lifetime
  vpn_ipsec_policy_pfs                  = var.vpn_ipsec_policy_pfs

  tags = local.tags
}
```

Notes:
- example of a full vpn tunnel to be found in the [Terratest section](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/terratest/vpn)  

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.34.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.34.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_vpnaas_endpoint_group_v2.local_peer](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpnaas_endpoint_group_v2) | resource |
| [opentelekomcloud_vpnaas_endpoint_group_v2.remote_peer](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpnaas_endpoint_group_v2) | resource |
| [opentelekomcloud_vpnaas_ike_policy_v2.ike_policy](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpnaas_ike_policy_v2) | resource |
| [opentelekomcloud_vpnaas_ipsec_policy_v2.ipsec_policy](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpnaas_ipsec_policy_v2) | resource |
| [opentelekomcloud_vpnaas_service_v2.vpnaas_service](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpnaas_service_v2) | resource |
| [opentelekomcloud_vpnaas_site_connection_v2.tunnel_connection](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpnaas_site_connection_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_local_router"></a> [local\_router](#input\_local\_router) | VPC id of the vpnaas service. | `string` | n/a | yes |
| <a name="input_local_subnets"></a> [local\_subnets](#input\_local\_subnets) | Local subnet CIDR ranges. | `set(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Prefix for all OTC resource names | `string` | n/a | yes |
| <a name="input_psk"></a> [psk](#input\_psk) | Pre shared key for vpn tunnel. | `string` | n/a | yes |
| <a name="input_remote_gateway"></a> [remote\_gateway](#input\_remote\_gateway) | Remote endpoint IPv4 address. | `string` | n/a | yes |
| <a name="input_remote_subnets"></a> [remote\_subnets](#input\_remote\_subnets) | Remote subnet CIDR ranges. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | n/a | yes |
| <a name="input_vpn_ike_policy_auth_algorithm"></a> [vpn\_ike\_policy\_auth\_algorithm](#input\_vpn\_ike\_policy\_auth\_algorithm) | Authentication hash algorithm | `string` | n/a | yes |
| <a name="input_vpn_ike_policy_dh_algorithm"></a> [vpn\_ike\_policy\_dh\_algorithm](#input\_vpn\_ike\_policy\_dh\_algorithm) | Diffie-Hellman key exchange algorithm | `string` | n/a | yes |
| <a name="input_vpn_ike_policy_encryption_algorithm"></a> [vpn\_ike\_policy\_encryption\_algorithm](#input\_vpn\_ike\_policy\_encryption\_algorithm) | Encryption algorithm | `string` | n/a | yes |
| <a name="input_vpn_ipsec_policy_auth_algorithm"></a> [vpn\_ipsec\_policy\_auth\_algorithm](#input\_vpn\_ipsec\_policy\_auth\_algorithm) | Authentication hash algorithm | `string` | n/a | yes |
| <a name="input_vpn_ipsec_policy_encryption_algorithm"></a> [vpn\_ipsec\_policy\_encryption\_algorithm](#input\_vpn\_ipsec\_policy\_encryption\_algorithm) | Encryption algorithm | `string` | n/a | yes |
| <a name="input_vpn_ipsec_policy_pfs"></a> [vpn\_ipsec\_policy\_pfs](#input\_vpn\_ipsec\_policy\_pfs) | The perfect forward secrecy mode | `string` | n/a | yes |
| <a name="input_vpn_ipsec_policy_protocol"></a> [vpn\_ipsec\_policy\_protocol](#input\_vpn\_ipsec\_policy\_protocol) | The security protocol used for IPSec to transmit and encapsulate user data. | `string` | n/a | yes |
| <a name="input_dpd"></a> [dpd](#input\_dpd) | Dead peer detection (true = hold (default) false = disabled). | `bool` | `true` | no |
| <a name="input_vpn_ike_policy_lifetime"></a> [vpn\_ike\_policy\_lifetime](#input\_vpn\_ike\_policy\_lifetime) | Lifetime of the security association in seconds. | `number` | `86400` | no |
| <a name="input_vpn_ipsec_policy_lifetime"></a> [vpn\_ipsec\_policy\_lifetime](#input\_vpn\_ipsec\_policy\_lifetime) | Lifetime of the security association in seconds. | `number` | `3600` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpn_tunnel_gateway"></a> [vpn\_tunnel\_gateway](#output\_vpn\_tunnel\_gateway) | n/a |
<!-- END_TF_DOCS -->
