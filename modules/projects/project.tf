resource "opentelekomcloud_identity_project_v3" "projects" {
  for_each    = var.projects
  name        = each.key
  description = each.value
}

#KMS Encryption for EVS volumes
resource "opentelekomcloud_identity_agency_v3" "evs_access_kms" {
  name                  = "EVSAccessKMS"
  description           = "EVSAccessKMS indicates that EVS has been assigned the KMS access rights for obtaining KMS keys to encrypt or decrypt disks."
  delegated_domain_name = "op_svc_evs"
  dynamic "project_role" {
    for_each = concat(values(opentelekomcloud_identity_project_v3.projects)[*].name, local.builtin_projects)
    content {
      project = project_role.value
      roles   = ["KMS Administrator", ]
    }
  }
}

#CCE rights
resource "opentelekomcloud_identity_agency_v3" "cce_admin_trust" {
  name                  = "cce_admin_trust"
  description           = "Create by CCE Team"
  delegated_domain_name = "op_svc_cce"
  dynamic "project_role" {
    for_each = concat(values(opentelekomcloud_identity_project_v3.projects)[*].name, local.builtin_projects)
    content {
      project = project_role.value
      roles   = ["Tenant Administrator", ]
    }
  }
}
