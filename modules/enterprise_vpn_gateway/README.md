## OTC Enterprise VPN Gateway Terraform module

A module pair (`enterprise_vpn_gateway`, `enterprise_vpn_connection`) designed to support full capabilities of OTC Enterpise VPN while simplifying the configuration for ease of use.

This module is primarily designed to be used with the module `enterprise_vpn_connection` but can support other use cases as well.

To use this module coupled with `enterprise_vpn_connection` module, please refer to [enterprise_vpn_connection](../enterprise_vpn_connection) module documentation.
For other use cases, all attributes of the created gateway resource is made available as `output.vpn_gateway` for flexibility.

Usage example
```hcl
module "enterprise_vpn_gateway" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/enterprise_vpn_gateway"

  name           = var.name
  vpc_id         = module.vpc.vpc.id
  connect_subnet = module.vpc.subnets["dmz-subnet"].network_id
  local_subnets  = [module.vpc.subnets["dmz-subnet"].cidr]
  ha_mode        = "active-active"
  tags           = var.tags
}
```

For more detailed information regarding individual gateway parameters please refer to: [OTC API Docs - Creating a VPN Gateway](https://docs.otc.t-systems.com/virtual-private-network/api-ref/api_reference_enterprise_edition_vpn/apis_of_enterprise_edition_vpn/vpn_gateway/creating_a_vpn_gateway.html)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.36.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.36.33 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_enterprise_vpn_gateway_v5.gateway](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/enterprise_vpn_gateway_v5) | resource |
| [opentelekomcloud_vpc_eip_v1.eips](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpc_eip_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Prefix for all OTC resource names. | `string` | n/a | yes |
| <a name="input_access_subnet_id"></a> [access\_subnet\_id](#input\_access\_subnet\_id) | The access subnet ID. The default value is the value of connect\_subnet. | `string` | `null` | no |
| <a name="input_access_vpc_id"></a> [access\_vpc\_id](#input\_access\_vpc\_id) | The access VPC ID. The default value is the value of vpc\_id. | `string` | `null` | no |
| <a name="input_asn"></a> [asn](#input\_asn) | The ASN number of BGP. The value ranges from 1 to 4,294,967,295. (Default: 64,512) | `number` | `64512` | no |
| <a name="input_attachment_type"></a> [attachment\_type](#input\_attachment\_type) | The attachment type. The value can be vpc and er. (Default: vpc) | `string` | `"vpc"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Set of availability zones for the VPN gateway. (Default: ["eu-de-01", "eu-de-02"]) | `list(string)` | <pre>[<br/>  "eu-de-01",<br/>  "eu-de-02"<br/>]</pre> | no |
| <a name="input_connect_subnet"></a> [connect\_subnet](#input\_connect\_subnet) | The Network ID of the VPC subnet used by the VPN gateway. This parameter is mandatory when attachment\_type is vpc. | `string` | `null` | no |
| <a name="input_eip_bandwidth"></a> [eip\_bandwidth](#input\_eip\_bandwidth) | The maximum bandwidth for the EIPs used by the VPN Gateway in Mbps. Only available if network\_mode is public. (Default: 1000) | `number` | `1000` | no |
| <a name="input_er_id"></a> [er\_id](#input\_er\_id) | The enterprise router ID to attach with to VPN gateway. This parameter is mandatory when attachment\_type is er. | `string` | `null` | no |
| <a name="input_flavor"></a> [flavor](#input\_flavor) | The flavor of the VPN gateway. The value can be Basic, Professional1, Professional2. (Default: Basic) | `string` | `"Basic"` | no |
| <a name="input_ha_mode"></a> [ha\_mode](#input\_ha\_mode) | The HA mode of VPN gateway. Valid values are active-active and active-standby. (Default: active-active) | `string` | `"active-active"` | no |
| <a name="input_local_subnets"></a> [local\_subnets](#input\_local\_subnets) | Local subnet CIDR ranges. This parameter is mandatory when attachment\_type is vpc. | `set(string)` | `null` | no |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | The network type. The value can be public and private. (Default: public) | `string` | `"public"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to which the VPN gateway is connected. This parameter is mandatory when attachment\_type is vpc. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | IP addresses of the VPN Gateway. In active-standby mode, the first ip in the list with 0 index is the master IP. |
| <a name="output_vpn_gateway"></a> [vpn\_gateway](#output\_vpn\_gateway) | Complete configuration for the created gateway resource. |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | UUID of the created gateway resource. |
<!-- END_TF_DOCS -->