resource "keycloak_saml_client" "otc" {
  client_id                 = var.otc_auth_endpoint
  base_url                  = var.otc_auth_endpoint
  client_signature_required = false
  description               = "Open Telekom Cloud access"
  name                      = "otc-idp"
  realm_id                  = var.keycloak_realm
  root_url                  = var.otc_auth_endpoint
  signature_algorithm       = "RSA_SHA256"
  valid_redirect_uris = [
    "${var.otc_auth_endpoint}/*",
  ]
}

resource "keycloak_saml_client_default_scopes" "otc_default_scopes" {
  realm_id  = keycloak_saml_client.otc.realm_id
  client_id = keycloak_saml_client.otc.id
  default_scopes = [
    "role_list",
    "otc-auth",
  ]
}
