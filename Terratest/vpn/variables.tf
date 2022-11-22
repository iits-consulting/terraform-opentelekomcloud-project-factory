#vpn tunnel configuration:
variable "vpn_dpd" {
  type        = bool
  description = "Dead peer detection (true = hold (default) false = disabled)"
  default     = true
}

variable "vpn_ike_policy_dh_algorithm" {
  type        = string
  description = "Diffie-Hellman key exchange algorithm"
  default     = null
}

variable "vpn_ike_policy_auth_algorithm" {
  type        = string
  description = "Authentication hash algorithm"
  default     = null
}

variable "vpn_ike_policy_encryption_algorithm" {
  type        = string
  description = "Encryption algorithm"
  default     = null
}

variable "vpn_ike_policy_lifetime" {
  type        = number
  description = "Lifetime of the security association in seconds."
  default     = null
}

variable "vpn_ipsec_policy_protocol" {
  type        = string
  description = "The security protocol used for IPSec to transmit and encapsulate user data."
  default     = null
}

variable "vpn_ipsec_policy_auth_algorithm" {
  type        = string
  description = "Authentication hash algorithm"
  default     = null
}

variable "vpn_ipsec_policy_encryption_algorithm" {
  type        = string
  description = "Encryption algorithm"
  default     = null
}

variable "vpn_ipsec_policy_lifetime" {
  type        = number
  description = "Lifetime of the security association in seconds."
  default     = null
}

variable "vpn_ipsec_policy_pfs" {
  type        = string
  description = "The perfect forward secrecy mode"
  default     = null
}


variable "region" {
  type        = string
  description = "OTC region for the project: eu-de(default) or eu-nl"
  validation {
    condition     = contains(["eu-de", "eu-nl", "eu-ch2"], var.region)
    error_message = "Allowed values for region are \"eu-de\", \"eu-nl\" or \"eu-ch\"."
  }
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