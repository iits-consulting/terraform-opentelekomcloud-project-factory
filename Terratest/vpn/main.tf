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


resource "random_password" "vpn_psk" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

module "vpn_tunnel_eu_nl" {
  source = "../../modules/vpn"
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

module "vpn_tunnel_eu_de" {
  source = "../../modules/vpn"
  name   = "${var.context}-${var.stage}-VPN"
  providers = {
    opentelekomcloud = opentelekomcloud.de
  }

  psk            = random_password.vpn_psk.result
  dpd            = var.vpn_dpd
  remote_gateway = module.vpn_tunnel_eu_nl.vpn_tunnel_gateway
  remote_subnets = values(local.eu_nl_subnets)
  local_router   = module.vpc_eu_de.vpc.id
  local_subnets  = values(local.eu_de_subnets)

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

data "opentelekomcloud_images_image_v2" "ubuntu_de" {
  provider   = opentelekomcloud.de
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

data "opentelekomcloud_images_image_v2" "ubuntu_nl" {
  provider   = opentelekomcloud.nl
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

module "jumphost_de" {
  source = "../../modules/jumphost"
  providers = {
    opentelekomcloud = opentelekomcloud.de
  }
  node_storage_encryption_enabled = true
  subnet_id                       = values(module.vpc_eu_de.subnets)[0].id
  node_name                       = "jumphost-${var.context}-${var.stage}"
  node_image_id                   = data.opentelekomcloud_images_image_v2.ubuntu_de.id
  cloud_init                      = join("\n", concat(["#cloud-config"], [for path in fileset("", "${path.root}/../../example_cloud_init/*.{yml,yaml}") : file(path)]))
}

module "jumphost_nl" {
  source = "../../modules/jumphost"
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }
  node_storage_encryption_enabled = true
  subnet_id                       = values(module.vpc_eu_nl.subnets)[0].id
  node_name                       = "jumphost-${var.context}-${var.stage}"
  node_image_id                   = data.opentelekomcloud_images_image_v2.ubuntu_nl.id
  cloud_init                      = join("\n", concat(["#cloud-config"], [for path in fileset("", "${path.root}/../../example_cloud_init/*.{yml,yaml}") : file(path)]))
}

output "jh_de" {
  value = module.jumphost_de.jumphost_address
}

output "jh_nl" {
  value = module.jumphost_nl.jumphost_address
}