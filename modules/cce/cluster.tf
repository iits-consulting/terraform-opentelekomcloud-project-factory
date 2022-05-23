resource "tls_private_key" "cluster_keypair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "opentelekomcloud_compute_keypair_v2" "cluster_keypair" {
  name       = "${var.name}-cluster-keypair"
  public_key = tls_private_key.cluster_keypair.public_key_openssh
}

resource "opentelekomcloud_vpc_eip_v1" "cce_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "${var.name}-cluster-kubectl-endpoint"
    share_type  = "PER"
    size        = 50
  }
  tags = var.tags
  publicip {
    type = "5_bgp"
  }
}

resource "random_id" "id" {
  count       = local.node_config.node_storage_encryption_enabled ? 1 : 0
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "node_storage_encryption_key" {
  count           = local.node_config.node_storage_encryption_enabled ? 1 : 0
  key_alias       = "${var.name}-node-pool-${random_id.id[0].hex}"
  key_description = "${var.name} CCE Node Pool volume encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

locals {
  flavor_id = "cce.${local.cluster_config.cluster_type == "BareMetal" ? "t" : "s"}${local.cluster_config.high_availability ? 2 : 1}.${lower(local.cluster_config.cluster_size)}"
}

resource "opentelekomcloud_cce_cluster_v3" "cluster" {
  name                    = var.name
  cluster_type            = local.cluster_config.cluster_type
  flavor_id               = local.flavor_id
  vpc_id                  = local.cluster_config.vpc_id
  subnet_id               = local.cluster_config.subnet_id
  container_network_type  = local.cluster_config.container_network_type
  container_network_cidr  = local.cluster_config.container_cidr
  kubernetes_svc_ip_range = local.cluster_config.service_cidr
  description             = "Kubernetes Cluster ${var.name}."
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
  name               = "${var.name}-node-pool"
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
  postinstall              = local.node_config.node_postinstall

  root_volume {
    size       = 50
    volumetype = "SSD"
  }

  data_volumes {
    size       = local.node_config.node_storage_size
    volumetype = local.node_config.node_storage_type
    kms_id     = local.node_config.node_storage_encryption_enabled ? opentelekomcloud_kms_key_v1.node_storage_encryption_key[0].id : null
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
  }
}
