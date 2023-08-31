resource "opentelekomcloud_identity_user_v3" "user" {
  name    = "${var.bucket_name}-user"
  enabled = true
}

resource "opentelekomcloud_identity_group_membership_v3" "user_to_obsgroup" {
  group = opentelekomcloud_identity_group_v3.obs_group.id
  users = [opentelekomcloud_identity_user_v3.user.id]
}

resource "opentelekomcloud_identity_credential_v3" "user_aksk" {
  user_id     = opentelekomcloud_identity_user_v3.user.id
  description = "Created by terraform"
}
