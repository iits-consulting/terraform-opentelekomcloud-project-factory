## OTC Enterprise VPN Connection Terraform module

A module pair (`enterprise_vpn_gateway`, `enterprise_vpn_connection`) designed to support full capabilities of OTC Enterpise VPN while simplifying the configuration for ease of use.

This module is designed to be used with the module `enterprise_vpn_gateway`.


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
locals {
  vpn_config = {
    ike_policy = {
      dh_group                 = "group21"
      authentication_algorithm = "sha2-512"
      encryption_algorithm     = "aes-256"
      lifetime_seconds         = 86400
    }
    ipsec_policy = {
      transform_protocol       = "esp"
      authentication_algorithm = "sha2-256"
      encryption_algorithm     = "aes-256"
      pfs                      = "group21"
      lifetime_seconds         = 3600
    }
  }
}
module "enterprise_vpn_connection" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/enterprise_vpn_connection"

  name                     = var.name
  otc_gateway_id           = module.enterprise_vpn_gateway.vpn_gateway.id
  otc_gateway_ip_selector  = "primary"
  remote_gateway_addresses = [var.remote_gateway_address]
  remote_subnets           = var.remote_subnets
  ike_policy               = local.vpn_config.ike_policy
  ipsec_policy             = local.vpn_config.ipsec_policy

  tags = local.tags
}
```
The module can also be configured to automatically create multiple connections in active-active or active-standby setups.
```hcl
// active-active: creates a 4 way connection between each IP address on local and remote side
module "enterprise_vpn_connection" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/enterprise_vpn_connection"

  name                     = var.name
  otc_gateway_id           = module.enterprise_vpn_gateway.vpn_gateway.id
  otc_gateway_ip_selector  = "both"
  remote_gateway_addresses = [var.remote_gateway_address_1, var.remote_gateway_address_2]
  remote_subnets           = var.remote_subnets
  ike_policy               = local.vpn_config.ike_policy
  ipsec_policy             = local.vpn_config.ipsec_policy

  tags = local.tags
}

// active-active: creates a 2 way connection with primary to primary and secondary to secondary
// active-standby: creates a 2 way connection with master to master and slave to slave
module "enterprise_vpn_connection" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/enterprise_vpn_connection"
  for_each = zipmap(["primary", "secondary"], [var.remote_gateway_address_1, var.remote_gateway_address_2])
  
  name                     = var.name
  otc_gateway_id           = module.enterprise_vpn_gateway.vpn_gateway.id
  otc_gateway_ip_selector  = each.key
  remote_gateway_addresses = [each.value]
  remote_subnets           = var.remote_subnets
  ike_policy               = local.vpn_config.ike_policy
  ipsec_policy             = local.vpn_config.ipsec_policy

  tags = local.tags
}
```

The parameter `otc_gateway_ip_selector` is an abstraction for both ease of use and a technical requirement to avoid object key dependencies in terraform.
It is designed to automatically determine the primary and secondary IP addresses used by the OTC Gateway, which is required by the API to be UUID or IP address depending on the network type.


`otc_gateway_ip_selector` will accept `primary`, `secondary` or `both` as valid options. `primary` and `secondary` correspond to the `eip1` and `eip2` in public networks and `access_private_ip_1` and `access_private_ip_2` in public networks respectively.


For more detailed information regarding individual connection parameters please refer to: [OTC API Docs - Creating a VPN Connection](https://docs.otc.t-systems.com/virtual-private-network/api-ref/api_reference_enterprise_edition_vpn/apis_of_enterprise_edition_vpn/vpn_connection/creating_a_vpn_connection.html#vpn-api-0027)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.36.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.36.31 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_enterprise_vpn_connection_monitor_v5.monitor](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/enterprise_vpn_connection_monitor_v5) | resource |
| [opentelekomcloud_enterprise_vpn_connection_v5.connection](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/enterprise_vpn_connection_v5) | resource |
| [opentelekomcloud_enterprise_vpn_customer_gateway_v5.remote_gateway](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/enterprise_vpn_customer_gateway_v5) | resource |
| [random_password.vpn_psk](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [opentelekomcloud_enterprise_vpn_gateway_v5.otc_gateway](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/enterprise_vpn_gateway_v5) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Prefix for all OTC resource names | `string` | n/a | yes |
| <a name="input_otc_gateway_id"></a> [otc\_gateway\_id](#input\_otc\_gateway\_id) | UUID of the enterprise VPN gateway to be used for this connection. | `string` | n/a | yes |
| <a name="input_remote_gateway_addresses"></a> [remote\_gateway\_addresses](#input\_remote\_gateway\_addresses) | Remote gateway endpoint IPv4 or FQDN addresses. | `set(string)` | n/a | yes |
| <a name="input_remote_subnets"></a> [remote\_subnets](#input\_remote\_subnets) | A list of remote subnet CIDR ranges. This parameter must be empty when the attachment\_type of the VPN gateway is set to er and vpn\_type is set to policy or bgp. | `set(string)` | n/a | yes |
| <a name="input_enable_nqa"></a> [enable\_nqa](#input\_enable\_nqa) | Enable NQA (Network Quality Analysis) for the connection. Depending on the configuration, it can break the connection if enabled. | `string` | `false` | no |
| <a name="input_ike_policy"></a> [ike\_policy](#input\_ike\_policy) | IKE (phase 1) policy parameters for the VPN tunnel. | <pre>object({<br/>    authentication_algorithm   = optional(string)<br/>    authentication_method      = optional(string)<br/>    encryption_algorithm       = optional(string)<br/>    dh_group                   = optional(string)<br/>    ike_version                = optional(string)<br/>    lifetime_seconds           = optional(number)<br/>    local_id_type              = optional(string)<br/>    local_id                   = optional(string)<br/>    peer_id_type               = optional(string)<br/>    peer_id                    = optional(string)<br/>    phase_one_negotiation_mode = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_ike_policy_dpd"></a> [ike\_policy\_dpd](#input\_ike\_policy\_dpd) | IKE policy dead peer detection (DPD) parameters for the VPN tunnel. | <pre>object({<br/>    timeout  = optional(number)<br/>    interval = optional(number)<br/>    msg      = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_ipsec_policy"></a> [ipsec\_policy](#input\_ipsec\_policy) | IPSec (phase 2) policy parameters for the VPN tunnel. | <pre>object({<br/>    authentication_algorithm = optional(string)<br/>    encryption_algorithm     = optional(string)<br/>    pfs                      = optional(string)<br/>    lifetime_seconds         = optional(number)<br/>    encapsulation_mode       = optional(string)<br/>    transform_protocol       = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_otc_gateway_ip_selector"></a> [otc\_gateway\_ip\_selector](#input\_otc\_gateway\_ip\_selector) | IP Address(es) selector for the enterprise VPN gateway desired to be used for this connection. Values can be "primary", "secondary" or "both". | `string` | `"both"` | no |
| <a name="input_policy_rules"></a> [policy\_rules](#input\_policy\_rules) | Policy based routing policy parameters for the VPN tunnel. | <pre>list(object({<br/>    rule_index  = optional(number)<br/>    destination = optional(string)<br/>    source      = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_psk"></a> [psk](#input\_psk) | IP Addresses for the enterprise VPN gateway of OTC. Will be autogenerated by module if not specified. | `string` | `""` | no |
| <a name="input_remote_gateway_asn"></a> [remote\_gateway\_asn](#input\_remote\_gateway\_asn) | The BGP ASN number of the remote gateway. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |
| <a name="input_vpn_connection_type"></a> [vpn\_connection\_type](#input\_vpn\_connection\_type) | The connection type. The value can be policy, static or bgp. | `string` | `"static"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection"></a> [connection](#output\_connection) | Complete configuration for the created connection resources. |
| <a name="output_remote_gateway"></a> [remote\_gateway](#output\_remote\_gateway) | Complete configuration for the created remote gateway (customer gateway) resources. |
| <a name="output_vpn_connection_psk"></a> [vpn\_connection\_psk](#output\_vpn\_connection\_psk) | PSK used by all created connection resources. |
<!-- END_TF_DOCS -->