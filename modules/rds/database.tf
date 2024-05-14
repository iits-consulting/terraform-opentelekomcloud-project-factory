resource "random_password" "db_root_password" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "random_id" "id" {
  count       = var.db_volume_encryption && var.db_volume_encryption_key_name == null ? 1 : 0
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "db_encryption_key" {
  count           = var.db_volume_encryption && var.db_volume_encryption_key_name == null ? 1 : 0
  key_alias       = "${var.name}-${random_id.id[0].hex}"
  key_description = "${var.name} RDS volume encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

data "opentelekomcloud_kms_key_v1" "db_encryption_existing_key" {
  count     = var.db_volume_encryption && var.db_volume_encryption_key_name != null ? 1 : 0
  key_alias = var.db_volume_encryption_key_name
}

resource "opentelekomcloud_vpc_eip_v1" "db_eip" {
  count = var.db_eip_bandwidth == 0 ? 0 : 1
  bandwidth {
    charge_mode = "traffic"
    name        = "${var.name}-public-ip"
    share_type  = "PER"
    size        = var.db_eip_bandwidth
  }
  tags = var.tags
  publicip {
    type = "5_bgp"
  }
  lifecycle {
    ignore_changes = [publicip[0].port_id]
  }
}

resource "opentelekomcloud_rds_instance_v3" "db_instance" {
  name                = var.name
  availability_zone   = var.db_high_availability || var.db_flavor != "" ? local.db_availability_zones : [local.db_availability_zones[0]]
  flavor              = local.db_flavor
  ha_replication_mode = local.db_ha_replication_mode
  security_group_id   = var.sg_secgroup_id == "" ? opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id : var.sg_secgroup_id
  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  public_ips          = var.db_eip_bandwidth == 0 ? [] : opentelekomcloud_vpc_eip_v1.db_eip[*].publicip[0].ip_address
  parameters          = var.db_parameters
  db {
    password = random_password.db_root_password.result
    type     = var.db_type
    version  = var.db_version
    port     = local.db_port
  }
  volume {
    disk_encryption_id = var.db_volume_encryption ? (var.db_volume_encryption_key_name == null ? opentelekomcloud_kms_key_v1.db_encryption_key[0].id : data.opentelekomcloud_kms_key_v1.db_encryption_existing_key[0].id) : null
    type               = var.db_storage_type
    size               = var.db_size
  }
  backup_strategy {
    start_time = var.db_backup_interval
    keep_days  = var.db_backup_days
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [db, availability_zone]
  }
  depends_on = [
    errorcheck_is_valid.db_flavor_constraint,
    errorcheck_is_valid.db_ha_replication_mode_constraint,
    data.opentelekomcloud_rds_flavors_v3.db_flavor,
  ]
}

locals {
  rds_ces_metric_dimensions = {
    MySQL      = "rds_instance_id"
    PostgreSQL = "postgresql_instance_id"
    SQLServer  = "rds_instance_sqlserver_id"
  }
}

resource "opentelekomcloud_ces_alarmrule" "db_storage_alarm" {
  count       = var.db_storage_alarm_threshold > 0 ? 1 : 0
  alarm_level = 2
  alarm_name  = replace("${var.name}-storage-alarm", "-", "_")
  metric {
    namespace   = "SYS.RDS"
    metric_name = "rds039_disk_util"
    dynamic "dimensions" {
      for_each = opentelekomcloud_rds_instance_v3.db_instance.nodes
      content {
        name  = local.rds_ces_metric_dimensions[var.db_type]
        value = dimensions.value.id
      }
    }
  }
  condition {
    period              = 1
    filter              = "average"
    comparison_operator = ">"
    value               = var.db_storage_alarm_threshold
    unit                = "%"
    count               = 5
  }
  alarm_action_enabled = false
}
