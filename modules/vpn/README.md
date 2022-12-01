## VPN Module

A module designed to create a vpn tunnel. 

Usage example:
```hcl
locals {
  eu_de_subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr_eu_de, 1, 0)
  }
  eu_nl_subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr_eu_nl, 1, 0)
  }
}

module "vpc_eu_nl" {
  source = "../../modules/vpc"
  name   = "${var.context}-${var.stage}-vpc"
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }

  cidr_block = var.vpc_cidr_eu_nl
  subnets    = local.eu_nl_subnets
  tags       = local.tags
}

module "vpc_eu_de" {
  source = "../../modules/vpc"
  name   = "${var.context}-${var.stage}-vpc"
  providers = {
    opentelekomcloud = opentelekomcloud.de
  }

  cidr_block = var.vpc_cidr_eu_de
  subnets    = local.eu_de_subnets
  tags       = local.tags
}

module "vpn_tunnel_eu_nl" {
  source = "../../modules/vpn"
  name   = "${var.context}-${var.stage}-VPN"
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }

  psk            = "demo_psk"
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
- example of a full vpn tunnel to be found in the [Terratest section](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/terratest/vpn)  