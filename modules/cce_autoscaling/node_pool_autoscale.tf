resource "opentelekomcloud_cce_node_pool_v3" "node_pool_autoscale" {
  cluster_id         = data.opentelekomcloud_cce_cluster_v3.cluster.id
  name               = local.node_pool_name
  flavor             = var.node_flavor
  initial_node_count = var.node_pool_node_count_initial
  availability_zone  = var.availability_zone
  key_pair           = var.ssh_key_pair_id
  os                 = var.nodes_os

  scale_enable             = true
  min_node_count           = var.node_pool_node_count_min
  max_node_count           = var.node_pool_node_count_max
  scale_down_cooldown_time = var.scale_down_cooldown_time_minutes
  priority                 = 1
  postinstall              = var.postinstall-script
  user_tags                = var.tags

  //noinspection HCLUnknownBlockType
  root_volume {
    size       = var.nodes_root_volume_size
    volumetype = var.nodes_root_volume_type
  }
  //noinspection HCLUnknownBlockType
  data_volumes {
    size       = var.nodes_data_volume_size
    volumetype = var.nodes_data_volume_type
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
    ]
  }
}