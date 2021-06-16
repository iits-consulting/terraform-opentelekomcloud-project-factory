resource "opentelekomcloud_identity_agency_v3" "enable_cce_auto_creation" {
  name                  = "cce_admin_trust_${var.project}"
  description           = "Created by Terraform to auto create cce"
  delegated_domain_name = "op_svc_cce"
  project_role {
    project = var.project
    roles = [
    "Tenant Administrator"]
  }
}