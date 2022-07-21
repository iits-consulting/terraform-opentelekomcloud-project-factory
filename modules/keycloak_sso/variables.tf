variable "keycloak_realm" {
  type        = string
  description = "Keycloak realm to create SAML client."
}

variable "keycloak_domain_name" {
  type        = string
  description = "The domain name for the."
}

variable "otc_idp_name" {
  type        = string
  description = "Name of the identity provider resources in OTC."
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
  description = "Authentication endpoint for OTC. Default: https://auth.otc.t-systems.com"
  default     = "https://auth.otc.t-systems.com"
}