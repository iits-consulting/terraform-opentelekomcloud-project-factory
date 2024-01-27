output "otc_sso_url" {
  value = "${var.otc_auth_endpoint}/authui/federation/websso?domain_id=${data.opentelekomcloud_identity_project_v3.current.domain_id}&idp=${var.otc_idp_name}&protocol=saml"
}