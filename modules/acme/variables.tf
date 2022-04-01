variable "otc_project_name" {
  type        = string
  description = "OTC project name in format \"eu-de_<project_name>\" or \"eu-nl_<project_name>\". The project must have the dns zone(s) created."
}

variable "otc_domain_name" {
  type        = string
  description = "OTC domain name for the cloud subscription. Usually in form OTC-EU-DE-000000000010XXXXXXXX"
}

variable "dns_admin_name" {
  type        = string
  description = "Name of the automated DNS admin user. (default: terraform_acme_dns_manager)"
  default     = "terraform_acme_dns_manager"
}

variable "domains" {
  type        = map(list(string))
  description = "Map of common names to alternative names to create ACME certificates. Module supports wildcard certificates, common name does not need to be included in alternative names."
}

variable "cert_key_type" {
  type        = string
  description = "The key type for the certificate's private key. Can be one of: P256 and P384 (for ECDSA keys of respective length) or 2048, 4096, and 8192 (for RSA keys of respective length). (default: P256)"
  default     = "P256"
  validation {
    condition     = contains(["P256", "P384", "2048", "4096", "8192"], var.cert_key_type)
    error_message = "Allowed values for cert_key_type are \"P256\", \"P384\", \"2048\", \"4096\", or \"8192\"."
  }
}

variable "cert_registration_email" {
  type        = string
  description = "E-mail associated with certificate generation."
}

variable "cert_registration_key_type" {
  type        = string
  description = "The key type for the ACME registration private key. Can be one of: P256 and P384 (for ECDSA keys of respective length) or 2048, 4096, and 8192 (for RSA keys of respective length). (default: P256)"
  default     = "P256"
  validation {
    condition     = contains(["P256", "P384", "2048", "4096", "8192"], var.cert_registration_key_type)
    error_message = "Allowed values for cert_registration_key_type are \"P256\", \"P384\", \"2048\", \"4096\", or \"8192\"."
  }
}

variable "cert_min_days_remaining" {
  type        = number
  description = "Number of days remaining when terraform apply will automatically renew the certificate. (default: 30)"
  default     = 30
}

