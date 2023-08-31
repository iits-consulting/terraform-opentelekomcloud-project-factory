data "opentelekomcloud_identity_project_v3" "toplevel" {
  name = var.region
}

data "opentelekomcloud_identity_project_v3" "obs_project" {
  name = "MOS"
}

data "opentelekomcloud_identity_role_v3" "obs_read_role" {
  name = "obs_b_list"
}

resource "opentelekomcloud_identity_group_v3" "obs_group" {
  name        = "${var.bucket_name}-group"
  description = "OBS bucket access group for ${var.bucket_name}."
}

resource "opentelekomcloud_identity_role_assignment_v3" "obs_role_to_obs_group" {
  group_id   = opentelekomcloud_identity_group_v3.obs_group.id
  project_id = data.opentelekomcloud_identity_project_v3.obs_project.id
  role_id    = data.opentelekomcloud_identity_role_v3.obs_read_role.id
}

data "opentelekomcloud_identity_role_v3" "kms_admin" {
  name = "kms_adm"
}

resource "opentelekomcloud_identity_role_assignment_v3" "kms_adm_to_obs_group" {
  group_id   = opentelekomcloud_identity_group_v3.obs_group.id
  project_id = data.opentelekomcloud_identity_project_v3.toplevel.id
  role_id    = data.opentelekomcloud_identity_role_v3.kms_admin.id
}
