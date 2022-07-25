resource "random_id" "id" {
  count       = var.es_volume_encryption ? 1 : 0
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "es_encryption_key" {
  count           = var.es_volume_encryption ? 1 : 0
  key_alias       = "${var.name}-${random_id.id[0].hex}"
  key_description = "${var.name} ES volume encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

resource "opentelekomcloud_css_cluster_v1" "cluster" {
  name            = var.name
  expect_node_num = 1
  tags            = var.tags
  datastore {
    type    = "elasticsearch"
    version = "7.9.3"
  }
  node_config {
    flavor            = var.es_flavor
    availability_zone = var.es_availability_zones[1]
    network_info {
      security_group_id = var.sg_secgroup_id
      network_id        = var.network_id
      vpc_id            = var.vpc_id
    }
    volume {
      volume_type    = var.es_storage_type
      size           = var.es_storage_size
      encryption_key = var.es_volume_encryption ? opentelekomcloud_kms_key_v1.es_encryption_key[0].id : null
    }
  }
}