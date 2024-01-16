variable "keycloak_realm" {
  type        = string
  description = "Keycloak realm to create SAML client."
}

variable "keycloak_domain_name" {
  type        = string
  description = "The domain name for the keycloak instance."
}

variable "keycloak_client_name" {
  type        = string
  description = "Keycloak Client name for the Open Telekom Cloud IDP client. (Default: otc-login"
  default     = "otc-login"
}

variable "otc_idp_name" {
  type        = string
  description = "Name of the identity provider resources in Open Telekom Cloud."
}

variable "otc_idp_rules" {
  type = string
  validation {
    condition     = can(jsondecode(var.otc_idp_rules))
    error_message = "Variable rules must be in JSON format!"
  }
}

variable "otc_auth_endpoint" {
  type        = string
  description = "Authentication endpoint for Open Telekom Cloud. Default: auth.otc.t-systems.com"
  default     = "auth.otc.t-systems.com"
}

// Ensure https protocol by stripping protocols in vars and adding https://
locals {
  keycloak_domain_name = "https://${trimprefix(trimprefix(var.keycloak_domain_name, "https://"), "http://")}"
  otc_auth_endpoint    = "https://${trimprefix(trimprefix(var.otc_auth_endpoint, "https://"), "http://")}"
}

data "opentelekomcloud_identity_project_v3" "current" {}

resource "errorcheck_is_valid" "provider_project_constraint" {
  name = "Check if the provider is not eu-nl."
  test = {
    assert        = data.opentelekomcloud_identity_project_v3.current.region != "eu-nl"
    error_message = "ERROR! This module is only available for providers with region eu-de. You may still use the module with an eu-de provider to log into both of the regions."
  }
}
