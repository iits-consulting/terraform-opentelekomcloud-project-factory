resource "opentelekomcloud_identity_group_v3" "obs_group" {
  name        = "${var.bucket_name}-group"
  description = "OBS bucket access group for ${var.bucket_name}."
}

data "opentelekomcloud_identity_project_v3" "obs_project" {
  name = "MOS"
}

resource "opentelekomcloud_identity_role_v3" "bucket_access" {
  display_name  = "${var.bucket_name}-obs-role"
  description   = "OBS bucket access role for ${var.bucket_name}."
  display_layer = "domain"
  statement {
    effect = "Allow"
    resource = [
      "obs:*:*:object:${opentelekomcloud_obs_bucket.bucket.id}/*",
      "obs:*:*:bucket:${opentelekomcloud_obs_bucket.bucket.id}"
    ]
    action = [
      "obs:bucket:ListAllMybuckets",
      "obs:bucket:HeadBucket",
      "obs:bucket:ListBucket",
      "obs:bucket:GetBucketLocation",
      "obs:object:GetObject",
      "obs:object:GetObjectVersion",
      "obs:object:PutObject",
      "obs:object:DeleteObject",
      "obs:object:DeleteObjectVersion",
      "obs:object:ListMultipartUploadParts",
      "obs:object:AbortMultipartUpload",
      "obs:object:GetObjectAcl",
      "obs:object:GetObjectVersionAcl",
    ]
  }
}

resource "opentelekomcloud_identity_role_assignment_v3" "obs_role_to_obs_group" {
  group_id   = opentelekomcloud_identity_group_v3.obs_group.id
  project_id = data.opentelekomcloud_identity_project_v3.obs_project.id
  role_id    = opentelekomcloud_identity_role_v3.bucket_access.id
}

data "opentelekomcloud_identity_project_v3" "current" {}

resource "opentelekomcloud_identity_role_v3" "kms_access" {
  display_name  = "${var.bucket_name}-kms-role"
  description   = "KMS encryption access role for ${var.bucket_name}."
  display_layer = "project"
  statement {
    effect = "Allow"
    resource = [
      "KMS:*:*:KeyId:${opentelekomcloud_kms_key_v1.bucket_kms_key.id}"
    ]
    action = [
      "kms:cmk:list",
      "kms:cmk:get",
      "kms:cmk:generate",
      "kms:dek:create",
      "kms:cmk:crypto",
      "kms:dek:crypto",
    ]
  }
}

resource "opentelekomcloud_identity_role_assignment_v3" "kms_adm_to_obs_group" {
  group_id   = opentelekomcloud_identity_group_v3.obs_group.id
  project_id = data.opentelekomcloud_identity_project_v3.current.id
  role_id    = opentelekomcloud_identity_role_v3.kms_access.id
}