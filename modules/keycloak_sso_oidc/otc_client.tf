resource "keycloak_openid_client" "otc" {
  realm_id                                 = var.keycloak_realm
  client_id                                = var.keycloak_client_name
  name                                     = var.keycloak_client_name
  enabled                                  = true
  standard_flow_enabled                    = true
  access_type                              = "PUBLIC"
  direct_access_grants_enabled             = true
  implicit_flow_enabled                    = true
  exclude_session_state_from_auth_response = null
  valid_redirect_uris = [
    "${local.otc_auth_endpoint}/*",
    "http://localhost:8088/*"
  ]
  client_authenticator_type = "client-jwt"
  extra_config = {
    "attributes.token.endpoint.auth.signing.alg" = "HS256"
  }
  web_origins                               = [""]
  oauth2_device_authorization_grant_enabled = true
}

resource "keycloak_openid_client_default_scopes" "otc_default_scopes" {
  realm_id  = keycloak_openid_client.otc.realm_id
  client_id = keycloak_openid_client.otc.id
  default_scopes = [
    "name",
    "email",
    "profile",
    "roles",
    "web-origins",
    "groups",
  ]
}
