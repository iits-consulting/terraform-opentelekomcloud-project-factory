data "opentelekomcloud_identity_project_v3" "current" {}

resource "opentelekomcloud_identity_user_v3" "user" {
  name    = var.username
  enabled = true
}

data "opentelekomcloud_identity_role_v3" "dns_admin_role" {
  name = "dns_adm"
}

resource "opentelekomcloud_identity_group_v3" "dns_admin_group" {
  name        = var.username
  description = "DNS Administrator group for ${var.release_name}."
}

resource "opentelekomcloud_identity_role_assignment_v3" "dns_admin_role_to_dns_group" {
  group_id   = opentelekomcloud_identity_group_v3.dns_admin_group.id
  project_id = data.opentelekomcloud_identity_project_v3.current.name == data.opentelekomcloud_identity_project_v3.current.region ? data.opentelekomcloud_identity_project_v3.current.id : data.opentelekomcloud_identity_project_v3.current.parent_id
  role_id    = data.opentelekomcloud_identity_role_v3.dns_admin_role.id
  lifecycle {
    ignore_changes = [project_id]
  }
}

resource "opentelekomcloud_identity_group_membership_v3" "user_to_dns_admin_group" {
  group = opentelekomcloud_identity_group_v3.dns_admin_group.id
  users = [opentelekomcloud_identity_user_v3.user.id]
}

resource "opentelekomcloud_identity_credential_v3" "user_aksk" {
  user_id     = opentelekomcloud_identity_user_v3.user.id
  description = "DNS Administrator user for ${var.release_name}."
}
