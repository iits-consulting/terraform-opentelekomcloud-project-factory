resource "opentelekomcloud_identity_group_v3" "dns_admin_group" {
  name        = "${var.dns_admin_name}-group"
  description = "Group for automated DNS administrators of ${var.otc_project_name}"
}

data "opentelekomcloud_identity_project_v3" "project" {
  name = var.otc_project_name
}

data "opentelekomcloud_identity_role_v3" "dns_admin_role" {
  name = "dns_adm"
}

resource "opentelekomcloud_identity_role_assignment_v3" "dns_admin_to_dns_admin_group" {
  group_id   = opentelekomcloud_identity_group_v3.dns_admin_group.id
  project_id = data.opentelekomcloud_identity_project_v3.project.id
  role_id    = data.opentelekomcloud_identity_role_v3.dns_admin_role.id
}

resource "time_rotating" "password_rotation" {
  rotation_days = 30
}

resource "random_password" "dns_admin_password" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  keepers = {
    created = time_rotating.password_rotation.rfc3339
  }
}

resource "opentelekomcloud_identity_user_v3" "dns_admin" {
  name        = var.dns_admin_name
  password    = random_password.dns_admin_password.result
  description = "Programmatic user for automated DNS administration for ACME DNS challenge."
  enabled     = true
  lifecycle {
    ignore_changes = [pwd_reset]
  }
}

resource "opentelekomcloud_identity_group_membership_v3" "dns_admin_membership" {
  group = opentelekomcloud_identity_group_v3.dns_admin_group.id
  users = [opentelekomcloud_identity_user_v3.dns_admin.id]
}
