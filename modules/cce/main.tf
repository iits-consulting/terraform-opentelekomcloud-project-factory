resource "opentelekomcloud_vpc_eip_v1" "cce_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "bandwidth-kubectl-${var.context_name}-${var.stage_name}"
    share_type  = "PER"
    size        = var.public_ip_bandwidth
  }
  tags        = var.tags
  publicip {
    type = "5_bgp"
  }
}

resource "opentelekomcloud_cce_cluster_v3" "cluster" {
  name                   = "${var.context_name}-${var.stage_name}"
  cluster_type           = "VirtualMachine"
  flavor_id              = var.vpc_flavor_id
  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  container_network_type = var.container_network_type
  description            = "Kubernetes Cluster for ${var.context_name} for the Stage ${var.stage_name}"
  region                 = var.region
  eip                    = opentelekomcloud_vpc_eip_v1.cce_eip.publicip[0].ip_address
  cluster_version        = var.cce_version

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "opentelekomcloud_cce_node_v3" "nodes" {
  for_each          = var.nodes
  cluster_id        = opentelekomcloud_cce_cluster_v3.cluster.id
  name              = "${var.node_name_prefix}-${var.stage_name}-${each.key}"
  availability_zone = var.availability_zone
  flavor_id         = each.value
  key_pair          = var.key_pair_id
  region            = var.region
  eip_count         = 0
  tags              = var.tags
  postinstall       = var.postinstall-script
  data_volumes {
    size       = var.nodes_data_volume_size
    volumetype = var.nodes_data_volume_type
  }
  root_volume {
    size       = var.nodes_root_volume_size
    volumetype = var.nodes_root_volume_type
  }
  lifecycle {
    ignore_changes = [
      annotations
    ]
  }
  timeouts {
    create = "20m"
    delete = "20m"
  }
}

output "endpoint" {
  value = local.kubectl_external_server
}

output "client-certificate" {
  value = local.client_certificate_data
}

output "client-key" {
  value = local.client_key_data
}

output "cluster-ca-certificate" {
  value = local.cluster_certificate_authority_data
}

output "cluster_id" {
  value = opentelekomcloud_cce_cluster_v3.cluster.id
}

output "cluster_name" {
  value = opentelekomcloud_cce_cluster_v3.cluster.name
}