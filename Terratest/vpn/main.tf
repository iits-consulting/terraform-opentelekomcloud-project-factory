locals {
  eu_de_subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr_eu_de, 1, 0)
  }
  eu_nl_subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr_eu_nl, 1, 0)
  }
}

resource "tls_private_key" "terraform_ssh_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

module "vpc_eu_nl" {
  source = "../../modules/vpc"
  name   = "${var.context}-${var.stage}-vpc"
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }

  cidr_block = var.vpc_cidr_eu_nl
  subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr_eu_nl, 1, 0)
  }
  tags = local.tags
}

module "vpc_eu_de" {
  source = "../../modules/vpc"
  name   = "${var.context}-${var.stage}-vpc"
  providers = {
    opentelekomcloud = opentelekomcloud.de
  }

  cidr_block = var.vpc_cidr_eu_de
  subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr_eu_de, 1, 0)
  }
  tags = local.tags
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
  remote_gateway = module.vpn_tunnel_eu_de.vpn_tunnel_gateway
  remote_subnets = values(local.eu_de_subnets)
  local_router   = module.vpc_eu_nl.vpc.id
  local_subnets  = values(module.vpc_eu_nl.subnets).*.cidr

  vpn_ike_policy_dh_algorithm         = var.vpn_ike_policy_dh_algorithm
  vpn_ike_policy_auth_algorithm       = var.vpn_ike_policy_auth_algorithm
  vpn_ike_policy_encryption_algorithm = var.vpn_ike_policy_encryption_algorithm

  vpn_ipsec_policy_protocol             = var.vpn_ipsec_policy_protocol
  vpn_ipsec_policy_auth_algorithm       = var.vpn_ipsec_policy_auth_algorithm
  vpn_ipsec_policy_encryption_algorithm = var.vpn_ipsec_policy_encryption_algorithm
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
  remote_gateway = module.vpn_tunnel_eu_nl.vpn_tunnel_gateway
  remote_subnets = values(local.eu_nl_subnets)
  local_router   = module.vpc_eu_de.vpc.id
  local_subnets  = values(module.vpc_eu_de.subnets).*.cidr

  vpn_ike_policy_dh_algorithm         = var.vpn_ike_policy_dh_algorithm
  vpn_ike_policy_auth_algorithm       = var.vpn_ike_policy_auth_algorithm
  vpn_ike_policy_encryption_algorithm = var.vpn_ike_policy_encryption_algorithm

  vpn_ipsec_policy_protocol             = var.vpn_ipsec_policy_protocol
  vpn_ipsec_policy_auth_algorithm       = var.vpn_ipsec_policy_auth_algorithm
  vpn_ipsec_policy_encryption_algorithm = var.vpn_ipsec_policy_encryption_algorithm
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

resource "opentelekomcloud_networking_secgroup_v2" "jumphost_secgroup_icmp_de" {
  provider             = opentelekomcloud.de
  name                 = "jumphost-eu-de-icmp-sg"
  description          = "Allow icmp traffic into the jumphost."
  delete_default_rules = true
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "jumphost_secgroup_rule_eu_de_icmp" {
  provider          = opentelekomcloud.de
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = values(local.eu_nl_subnets)[0]
  security_group_id = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup_icmp_de.id

  description = "Allow icmp traffic into the jumphost."
}

resource "opentelekomcloud_networking_secgroup_v2" "jumphost_secgroup_icmp_nl" {
  provider             = opentelekomcloud.nl
  name                 = "jumphost-eu-nl-icmp-sg"
  description          = "Allow icmp traffic into the jumphost."
  delete_default_rules = true
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "jumphost_secgroup_rule_eu_nl_icmp" {
  provider          = opentelekomcloud.nl
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = values(local.eu_de_subnets)[0]
  security_group_id = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup_icmp_nl.id

  description = "Allow icmp traffic into the jumphost."
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
  cloud_init                      = replace(file("${path.root}/users.yaml"), "{terraform_public_key}", tls_private_key.terraform_ssh_key.public_key_openssh)
  additional_security_groups      = [opentelekomcloud_networking_secgroup_v2.jumphost_secgroup_icmp_de.name]
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
  cloud_init                      = replace(file("${path.root}/users.yaml"), "{terraform_public_key}", tls_private_key.terraform_ssh_key.public_key_openssh)
  additional_security_groups      = [opentelekomcloud_networking_secgroup_v2.jumphost_secgroup_icmp_nl.name]
}

#the connection test will only succeed once both jumphosts are done initializing
resource "time_sleep" "wait_180_seconds" {
  triggers = {
    jumphost_nl = module.jumphost_nl.jumphost_private_address
    jumphost_de = module.jumphost_de.jumphost_private_address
  }

  create_duration = "180s"
}

resource "null_resource" "ping_to_nl" {
  connection {
    host        = module.jumphost_de.jumphost_address
    type        = "ssh"
    user        = "terraform"
    private_key = tls_private_key.terraform_ssh_key.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = ["ping -c 5 ${module.jumphost_nl.jumphost_private_address}"]
  }

  depends_on = [
    time_sleep.wait_180_seconds
  ]
}

resource "null_resource" "ping_to_de" {
  connection {
    host        = module.jumphost_nl.jumphost_address
    type        = "ssh"
    user        = "terraform"
    private_key = tls_private_key.terraform_ssh_key.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = ["ping -c 5 ${module.jumphost_de.jumphost_private_address}"]
  }

  depends_on = [
    time_sleep.wait_180_seconds
  ]
}