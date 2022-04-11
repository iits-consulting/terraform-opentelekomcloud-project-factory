resource "opentelekomcloud_identity_user_v3" "icagentinstaller" {
  name = "icagentinstaller"
}

data "opentelekomcloud_identity_role_v3" "apm_admin" {
  name = "apm_adm"
}

resource "opentelekomcloud_identity_group_v3" "apm_admins" {
  name = "apm_admins"
}

resource "opentelekomcloud_identity_group_membership_v3" "apm_admins" {
  group = opentelekomcloud_identity_group_v3.apm_admins.id
  users = [opentelekomcloud_identity_user_v3.icagentinstaller.id]
}

resource "opentelekomcloud_identity_role_assignment_v3" "icagentinstaller_apm_admin" {
  group_id   = opentelekomcloud_identity_group_v3.apm_admins.id
  project_id = var.otc_project_id
  role_id    = data.opentelekomcloud_identity_role_v3.apm_admin.id
}

resource "opentelekomcloud_identity_credential_v3" "icagentinstaller_keys" {
  user_id     = opentelekomcloud_identity_user_v3.icagentinstaller.id
  status      = "active"
  description = "Access and Secret Key of ICAgent Installer (installs ICAgent on Kubernetes Nodes)"
}

output "node-postinstall-script" {
  depends_on = [
    opentelekomcloud_identity_credential_v3.icagentinstaller_keys,
  opentelekomcloud_identity_role_assignment_v3.icagentinstaller_apm_admin]
  value = "curl ${local.ic_agent_install_script} > apm_agent_install.sh && REGION=${var.region} bash apm_agent_install.sh -ak ${opentelekomcloud_identity_credential_v3.icagentinstaller_keys.access} -sk ${opentelekomcloud_identity_credential_v3.icagentinstaller_keys.secret} -region ${var.region} -projectid ${var.otc_project_id} -obsdomain ${var.obs_domain} -accessip ${var.aom_access_ip};"
}