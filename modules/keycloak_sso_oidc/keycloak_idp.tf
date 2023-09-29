data "curl" "oidc_keys" {
  http_method = "GET"
  uri         = "${local.keycloak_domain_name}/realms/${var.keycloak_realm}/protocol/openid-connect/certs"
}

resource "errorcheck_is_valid" "cert_endpoint_check" {
  name = "Check if the the result is JSON and has at least 1 key in it."
  test = {
    assert        = length(jsondecode(data.curl.oidc_keys.response)) > 0
    error_message = "ERROR! Signing keys defined at \"${local.keycloak_domain_name}/realms/${var.keycloak_realm}/protocol/openid-connect/certs\" are missing or malformed."
  }
}

resource "opentelekomcloud_identity_provider" "provider" {
  name        = var.otc_idp_name
  description = "Keycloak Open ID Connect Single Sign On for OTC."
  protocol    = "oidc"

  mapping_rules = var.otc_idp_rules

  access_config {
    access_type            = "program_console"
    response_type          = "id_token"
    response_mode          = "form_post"
    provider_url           = "${local.keycloak_domain_name}/realms/${var.keycloak_realm}"
    client_id              = var.keycloak_client_name
    authorization_endpoint = "${local.keycloak_domain_name}/realms/${var.keycloak_realm}/protocol/openid-connect/auth"
    scopes                 = ["openid"]
    signing_key            = data.curl.oidc_keys.response
  }
  depends_on = [errorcheck_is_valid.cert_endpoint_check]
}
