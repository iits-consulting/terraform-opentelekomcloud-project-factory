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

resource "opentelekomcloud_blockstorage_volume_v2" "jumphost_boot_volume" {
  name              = "${var.node_name}-volume"
  description       = "${var.node_name} system volume device."
  availability_zone = local.availability_zone
  size              = var.node_storage_size
  volume_type       = var.node_storage_type
  image_id          = var.node_image_id

  metadata = merge({
    attached_mode = "rw"
    readonly      = "False"
    }, local.node_storage_encryption_enabled ? {
    __system__encrypted = "1"
    __system__cmkid     = var.node_storage_encryption_key_name == null ? opentelekomcloud_kms_key_v1.jumphost_storage_encryption_key[0].id : data.opentelekomcloud_kms_key_v1.jumphost_storage_existing_encryption_key[0].id
  } : {})
  tags = var.tags
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "opentelekomcloud_compute_instance_v2" "jumphost_node" {
  name          = var.node_name
  image_id      = var.node_image_id
  auto_recovery = true
  flavor_id     = var.node_flavor

  network {
    uuid           = var.subnet_id
    access_network = true
  }
  user_data = base64encode(sensitive(join("\n", [var.cloud_init, local.cloud_init_host_keys])))

  block_device {
    uuid                  = opentelekomcloud_blockstorage_volume_v2.jumphost_boot_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }

  availability_zone = local.availability_zone
  security_groups = concat([
    opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.name
  ], var.additional_security_groups)
  timeouts {
    create = "20m"
    delete = "20m"
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "opentelekomcloud_networking_floatingip_associate_v2" "jumphost_eip_association" {
  floating_ip = opentelekomcloud_vpc_eip_v1.jumphost_eip.publicip[0].ip_address
  port_id     = opentelekomcloud_compute_instance_v2.jumphost_node.network[0].port
}
