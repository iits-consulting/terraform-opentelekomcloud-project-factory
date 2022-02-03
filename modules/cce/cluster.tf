resource "tls_private_key" "cluster_keypair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "opentelekomcloud_compute_keypair_v2" "cluster_keypair" {
  name       = "${var.context}-${var.stage}-cluster-keypair"
  public_key = tls_private_key.cluster_keypair.public_key_openssh
}

resource "opentelekomcloud_vpc_eip_v1" "cce_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "${var.context}-${var.stage}-cluster-kubectl-endpoint"
    share_type  = "PER"
    size        = 50
  }
  tags = var.tags
  publicip {
    type = "5_bgp"
  }
}

locals {
  flavor_id = "cce.${local.cluster_config.cluster_type == "BareMetal" ? "t" : "s"}${local.cluster_config.high_availability ? 2 : 1}.${lower(local.cluster_config.cluster_size)}"
}

resource "opentelekomcloud_cce_cluster_v3" "cluster" {
  name                    = "${var.context}-${var.stage}"
  cluster_type            = local.cluster_config.cluster_type
  flavor_id               = local.flavor_id
  vpc_id                  = local.cluster_config.vpc_id
  subnet_id               = local.cluster_config.subnet_id
  container_network_type  = local.cluster_config.cluster_type == "BareMetal" ? "underlay_ipvlan" : "vpc-router"
  container_network_cidr  = local.cluster_config.container_cidr
  kubernetes_svc_ip_range = local.cluster_config.service_cidr
  description             = "Kubernetes Cluster for ${var.context}."
  eip                     = opentelekomcloud_vpc_eip_v1.cce_eip.publicip[0].ip_address
  cluster_version         = local.cluster_config.cluster_version
  authentication_mode     = "x509"

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "opentelekomcloud_cce_node_pool_v3" "cluster_node_pool" {
  cluster_id         = opentelekomcloud_cce_cluster_v3.cluster.id
  name               = "${var.context}-${var.stage}-node-pool"
  flavor             = local.node_config.node_flavor
  initial_node_count = local.node_config.node_count
  availability_zone  = local.node_config.availability_zones[0]
  key_pair           = opentelekomcloud_compute_keypair_v2.cluster_keypair.name
  os                 = local.node_config.node_os

  scale_enable             = local.cluster_config.enable_scaling
  min_node_count           = local.autoscaling_config.nodes_min
  max_node_count           = local.autoscaling_config.nodes_max
  scale_down_cooldown_time = 15
  priority                 = 1
  user_tags                = var.tags
  docker_base_size         = 20

  //noinspection HCLUnknownBlockType
  root_volume {
    size       = 50
    volumetype = "SSD"
  }
  //noinspection HCLUnknownBlockType
  data_volumes {
    size       = local.node_config.node_storage_size
    volumetype = local.node_config.node_storage_type
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
  }
}
