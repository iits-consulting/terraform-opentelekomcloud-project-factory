## VPN Module

A module designed to create a vpn tunnel. 

Usage example:
```hcl
module "vpc" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  name   = "${var.context}-${var.stage}-vpc"

  cidr_block = var.vpc_cidr
  subnets    = {
    "vpn-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
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
  name   = "${var.context}-${var.stage}-VPN"

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