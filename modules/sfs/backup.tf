resource "opentelekomcloud_cbr_policy_v3" "backup_policy" {
  count           = var.backup_enabled ? 1 : 0
  name            = "${var.volume_name}-backup-policy"
  operation_type  = "backup"
  trigger_pattern = var.backup_trigger_pattern
  operation_definition {
    retention_duration_days = var.backup_retention_days
    timezone                = "UTC+02:00"
  }
}

resource "opentelekomcloud_cbr_vault_v3" "backup_vault" {
  count            = var.backup_enabled ? 1 : 0
  name             = "${var.volume_name}-backup-vault"
  description      = "CBR vault for SFS Turbo instance ${var.volume_name}"
  backup_policy_id = opentelekomcloud_cbr_policy_v3.backup_policy[0].id
  billing {
    size          = var.backup_size
    object_type   = "turbo"
    protect_type  = "backup"
    charging_mode = "post_paid"
  }
  resource {
    id   = opentelekomcloud_sfs_turbo_share_v1.sfs_volume.id
    type = "OS::Sfs::Turbo"
  }
}
