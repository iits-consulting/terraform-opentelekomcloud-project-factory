#vpn tunnel configuration:

variable "vpn_ike_policy_dh_algorithm" {
  type        = string
  description = "Diffie-Hellman key exchange algorithm"
}

variable "vpn_ike_policy_auth_algorithm" {
  type        = string
  description = "Authentication hash algorithm"
}

variable "vpn_ike_policy_encryption_algorithm" {
  type        = string
  description = "Encryption algorithm"
}
variable "vpn_ipsec_policy_protocol" {
  type        = string
  description = "The security protocol used for IPSec to transmit and encapsulate user data."
}

variable "vpn_ipsec_policy_auth_algorithm" {
  type        = string
  description = "Authentication hash algorithm"
}

variable "vpn_ipsec_policy_encryption_algorithm" {
  type        = string
  description = "Encryption algorithm"
}

variable "vpn_ipsec_policy_pfs" {
  type        = string
  description = "The perfect forward secrecy mode"
}

variable "vpc_cidr_eu_nl" {
  type        = string
  description = "IP range of the VPC"
}

variable "vpc_cidr_eu_de" {
  type        = string
  description = "IP range of the VPC"
}

variable "context" {
  type        = string
  description = "Project context for resource naming and tagging."
}

variable "stage" {
  type        = string
  description = "Project stage for resource naming and tagging."
}

locals {
  tags = {
    Stage   = var.stage
    Context = var.context
  }
}