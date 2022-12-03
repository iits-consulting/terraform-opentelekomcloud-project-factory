## VPN Module

A module designed to create a vpn tunnel. 

Usage example:
```hcl
module "vpn_tunnel_eu_nl" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpn"
  name   = "${var.context}-${var.stage}-VPN"
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }

  psk            = random_password.vpn_psk.result
  dpd            = var.vpn_dpd
  remote_gateway = module.vpn_tunnel_eu_de.vpn_tunnel_gateway
  remote_subnets = values(local.eu_de_subnets)
  local_router   = module.vpc_eu_nl.vpc.id
  local_subnets  = values(local.eu_nl_subnets)

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
- this creates a vpn tunnel from a vpc on region eu-nl into a vpc on region eu-de
- if not specified explicitly the local_subnets are going to be the subnets of the local_router
- example of a full vpn tunnel to be found in the [Terratest section](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/terratest/vpn)  