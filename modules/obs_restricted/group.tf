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
      "obs:*:*:bucket:${opentelekomcloud_obs_bucket.bucket.id}"
    ]
    action = [
      "obs:bucket:ListAllMybuckets",
      "obs:bucket:HeadBucket",
      "obs:bucket:ListBucket",
      "obs:bucket:GetBucketLocation",
      "obs:bucket:ListBucketMultipartUploads",
    ]
  }
  statement {
    effect = "Allow"
    resource = [
      "obs:*:*:object:${opentelekomcloud_obs_bucket.bucket.id}/*",
    ]
    action = [
      "obs:object:GetObject",
      "obs:object:GetObjectVersion",
      "obs:object:PutObject",
      "obs:object:DeleteObject",
      "obs:object:DeleteObjectVersion",
      "obs:object:ListMultipartUploadParts",
      "obs:object:AbortMultipartUpload",
      "obs:object:GetObjectAcl",
      "obs:object:GetObjectVersionAcl",
      "obs:object:ModifyObjectMetaData",
    ]
  }
}

resource "opentelekomcloud_identity_role_assignment_v3" "obs_role_to_obs_group" {
  group_id   = opentelekomcloud_identity_group_v3.obs_group.id
  project_id = data.opentelekomcloud_identity_project_v3.obs_project.id
  role_id    = opentelekomcloud_identity_role_v3.bucket_access.id
  lifecycle {
    ignore_changes = [project_id]
  }
}

data "opentelekomcloud_identity_project_v3" "current" {}

resource "errorcheck_is_valid" "provider_project_constraint" {
  name = "Check if the provider is correctly set to top level project."
  test = {
    assert        = data.opentelekomcloud_identity_project_v3.current.name == data.opentelekomcloud_identity_project_v3.current.region
    error_message = "ERROR! This module requires the provider project (tenant_name) to be a region level project. See README.md for more information."
  }
}

resource "opentelekomcloud_identity_role_v3" "kms_access" {
  display_name  = "${var.bucket_name}-kms-role"
  description   = "KMS encryption access role for ${var.bucket_name}."
  display_layer = "project"
  statement {
    effect = "Allow"
    action = [
      "kms:cmk:list",
      "kms:cmk:get",
    ]
  }
  statement {
    effect = "Allow"
    resource = [
      "KMS:*:*:KeyId:${opentelekomcloud_kms_key_v1.bucket_kms_key.id}"
    ]
    action = [
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
  lifecycle {
    ignore_changes = [project_id]
  }
}