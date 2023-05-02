### mandatories
variable "name" {
  type        = string
  description = "Prefix for all OTC resource names"
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
}

variable "psk" {
  type        = string
  description = "Pre shared key for vpn tunnel."
}

// The DPD is not supported according to https://docs.otc.t-systems.com/api/vpn/en_topic_0093011492.html but exists in terraform provider.
variable "dpd" {
  type        = bool
  description = "Dead peer detection (true = hold (default) false = disabled)."
  default     = true
}

variable "local_router" {
  type        = string
  description = "VPC id of the vpnaas service."
}

variable "local_subnets" {
  type        = set(string)
  description = "Local subnet CIDR ranges."
}


variable "remote_gateway" {
  type        = string
  description = "Remote endpoint IPv4 address."
}

// If remote subnet ranges include 100.64.0.0/10 range, it may cause services such as OBS, DNS, API Gateway to become unavailable.
variable "remote_subnets" {
  type        = set(string)
  description = "Remote subnet CIDR ranges."
}

#IKE policy parameters for the VPN tunnel:
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

variable "vpn_ike_policy_lifetime" {
  type        = number
  description = "Lifetime of the security association in seconds."
  default     = 86400
}

#IPSec policy parameters for the VPN tunnel:
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

variable "vpn_ipsec_policy_lifetime" {
  type        = number
  description = "Lifetime of the security association in seconds."
  default     = 3600
}

variable "vpn_ipsec_policy_pfs" {
  type        = string
  description = "The perfect forward secrecy mode"
}
