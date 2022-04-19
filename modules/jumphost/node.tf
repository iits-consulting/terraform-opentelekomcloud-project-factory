data "template_cloudinit_config" "config" {
  part {
    content_type = "text/cloud-config"
    content      = length(var.users_config_path) == 0 ? "" : file(var.users_config_path)
  }
  dynamic "part" {
    for_each = length(var.cloud_init_path) == 0 ? toset([]) : toset(fileset(var.cloud_init_path, "*.{yml,yaml}"))
    content {
      content_type = "text/cloud-config"
      content      = file(part.value)
    }
  }
}

resource "opentelekomcloud_vpc_eip_v1" "jumphost_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "${var.node_name}-bandwidth"
    share_type  = "PER"
    size        = var.node_bandwidth_size
  }
  publicip {
    type = "5_bgp"
  }
  tags = var.tags
}

resource "opentelekomcloud_ecs_instance_v1" "jumphost_node" {
  name          = var.node_name
  image_id      = var.node_image_id
  auto_recovery = true
  flavor        = var.node_flavor
  vpc_id        = var.vpc_id

  nics {
    network_id = var.subnet_id
  }
  user_data = data.template_cloudinit_config.config.rendered

  system_disk_type = var.node_storage_type
  system_disk_size = var.node_storage_size

  availability_zone = "eu-de-03"
  key_name          = opentelekomcloud_compute_keypair_v2.jumphost_keypair.name
  security_groups   = concat([opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id], var.additional_security_groups)
  timeouts {
    create = "20m"
    delete = "20m"
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "jumphost_eip_association" {
  floating_ip = opentelekomcloud_vpc_eip_v1.jumphost_eip.publicip[0].ip_address
  instance_id = opentelekomcloud_ecs_instance_v1.jumphost_node.id
}