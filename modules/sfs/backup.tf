resource "opentelekomcloud_cbr_policy_v3" "backup_policy" {
  name           = "${var.volume_name}-backup-policy"
  operation_type = "backup"

  trigger_pattern = [
    "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU;BYHOUR=00;BYMINUTE=00"
  ]
  operation_definition {
    retention_duration_days = 7
    timezone                = "UTC+02:00"
  }

}

resource "opentelekomcloud_cbr_vault_v3" "backup_vault" {
  name = "${var.volume_name}-backup-vault"

  description = "CBR vault for SFS Turbo instance ${var.volume_name}"

  backup_policy_id = opentelekomcloud_cbr_policy_v3.backup_policy.id

  billing {
    size          = var.size * 2
    object_type   = "turbo"
    protect_type  = "backup"
    charging_mode = "post_paid"
  }

  resource {
    id   = opentelekomcloud_sfs_turbo_share_v1.sfs_volume.id
    type = "OS::Sfs::Turbo"
  }
}

