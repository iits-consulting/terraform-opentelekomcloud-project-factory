resource "tls_private_key" "cluster_keypair" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "random_id" "cluster_keypair_id" {
  byte_length = 4
}

resource "opentelekomcloud_compute_keypair_v2" "cluster_keypair" {
  name       = "${var.name}-cluster-keypair-${random_id.cluster_keypair_id.hex}"
  public_key = tls_private_key.cluster_keypair.public_key_openssh
}

resource "opentelekomcloud_vpc_eip_v1" "cce_eip" {
  count = var.cluster_public_access ? 1 : 0
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
  count       = var.node_storage_encryption_enabled && var.node_storage_encryption_kms_key_name == null ? 1 : 0
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "node_storage_encryption_key" {
  count           = var.node_storage_encryption_enabled && var.node_storage_encryption_kms_key_name == null ? 1 : 0
  key_alias       = "${var.name}-node-pool-${random_id.id[0].hex}"
  key_description = "${var.name} CCE Node Pool volume encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

data "opentelekomcloud_kms_key_v1" "node_storage_encryption_existing_key" {
  count     = var.node_storage_encryption_enabled && var.node_storage_encryption_kms_key_name != null ? 1 : 0
  key_alias = var.node_storage_encryption_kms_key_name
}

locals {
  node_storage_encryption_enabled = data.opentelekomcloud_identity_project_v3.current.region != "eu-de" ? false : var.node_storage_encryption_enabled
  flavor_id                       = "cce.${var.cluster_type == "BareMetal" ? "t" : "s"}${var.cluster_high_availability ? 2 : 1}.${lower(var.cluster_size)}"
}

resource "opentelekomcloud_cce_cluster_v3" "cluster" {
  name                     = var.name
  cluster_type             = var.cluster_type
  flavor_id                = local.flavor_id
  vpc_id                   = var.cluster_vpc_id
  subnet_id                = var.cluster_subnet_id
  container_network_type   = local.cluster_container_network_type
  container_network_cidr   = var.cluster_container_cidr
  kubernetes_svc_ip_range  = var.cluster_service_cidr
  description              = "Kubernetes Cluster ${var.name}."
  eip                      = var.cluster_public_access ? opentelekomcloud_vpc_eip_v1.cce_eip[0].publicip[0].ip_address : null
  cluster_version          = var.cluster_version
  authentication_mode      = var.cluster_authentication_mode
  annotations              = var.cluster_install_icagent ? { "cluster.install.addons.external/install" = jsonencode([{ addonTemplateName = "icagent" }]) } : null
  enable_volume_encryption = var.cluster_enable_volume_encryption
  dynamic "authenticating_proxy" {
    for_each = var.cluster_authentication_mode != "authenticating_proxy" ? toset([]) : toset(["authenticating_proxy"])
    content {
      ca          = var.cluster_authenticating_proxy_ca
      cert        = var.cluster_authenticating_proxy_cert
      private_key = var.cluster_authenticating_proxy_private_key
    }
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "opentelekomcloud_cce_node_pool_v3" "cluster_node_pool" {
  for_each           = var.node_availability_zones
  cluster_id         = opentelekomcloud_cce_cluster_v3.cluster.id
  name               = "${var.name}-nodes-${each.value}"
  flavor             = var.node_flavor
  initial_node_count = var.node_count
  availability_zone  = each.value
  key_pair           = opentelekomcloud_compute_keypair_v2.cluster_keypair.name
  os                 = var.node_os
  runtime            = var.node_container_runtime

  scale_enable             = var.cluster_enable_scaling
  min_node_count           = local.autoscaler_node_min
  max_node_count           = var.autoscaler_node_max
  scale_down_cooldown_time = 15
  priority                 = 1
  user_tags                = var.tags
  docker_base_size         = 20
  postinstall              = var.node_postinstall

  k8s_tags = var.node_k8s_tags

  dynamic "taints" {
    for_each = var.node_taints
    content {
      effect = taints.value.effect
      key    = taints.value.key
      value  = taints.value.value
    }
  }

  root_volume {
    size       = 50
    volumetype = "SSD"
    kms_id     = var.node_storage_encryption_enabled ? (var.node_storage_encryption_kms_key_name == null ? opentelekomcloud_kms_key_v1.node_storage_encryption_key[0].id : data.opentelekomcloud_kms_key_v1.node_storage_encryption_existing_key[0].id) : null
  }

  data_volumes {
    size       = var.node_storage_size
    volumetype = var.node_storage_type
    kms_id     = var.node_storage_encryption_enabled ? (var.node_storage_encryption_kms_key_name == null ? opentelekomcloud_kms_key_v1.node_storage_encryption_key[0].id : data.opentelekomcloud_kms_key_v1.node_storage_encryption_existing_key[0].id) : null
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
    create_before_destroy = true
  }
}
