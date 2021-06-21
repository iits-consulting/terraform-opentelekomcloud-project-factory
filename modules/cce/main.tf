resource "opentelekomcloud_vpc_eip_v1" "cce_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "bandwidth-kubectl-${var.context_name}-${var.stage_name}"
    share_type  = "PER"
    size        = var.public_ip_bandwidth
  }
  tags = var.tags
  publicip {
    type = "5_bgp"
  }
}

resource "opentelekomcloud_cce_cluster_v3" "cluster" {
  name                   = "${var.context_name}-${var.stage_name}"
  cluster_type           = "VirtualMachine"
  flavor_id              = var.cce_flavor_id
  vpc_id                 = var.vpc_id
  subnet_id              = var.subnet_id
  container_network_type = var.container_network_type
  description            = "Kubernetes Cluster for ${var.context_name} for the Stage ${var.stage_name}"
  region                 = var.region
  eip                    = opentelekomcloud_vpc_eip_v1.cce_eip.publicip[0].ip_address
  cluster_version        = var.cce_version
  authentication_mode    = var.cce_authentication_mode

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

resource "opentelekomcloud_cce_node_v3" "nodes" {
  count             = length(var.nodes)
  cluster_id        = opentelekomcloud_cce_cluster_v3.cluster.id
  name              = "${var.node_name_prefix}-${var.stage_name}-${count.index}"
  availability_zone = var.availability_zone
  flavor_id         = var.nodes[count.index]
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
