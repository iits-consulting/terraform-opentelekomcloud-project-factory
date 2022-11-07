variable "tags" {
  type        = map(string)
  description = "Common tag set for PEGA project resources"
  default     = {}
}

variable "certificate" {
  type        = string
  description = "Signed certificate in PEM format for the domain(s)."
  default     = ""
}

variable "certificate_private_key" {
  type        = string
  description = "Private key of the certificate in PEM format for the domain(s)."
  default     = ""
}

resource "errorcheck_is_valid" "certificate_required" {
  name = "Certificate Required"
  test = {
    assert        = length(var.certificate) != 0 || var.client_insecure
    error_message = "The variable certificate is required if client_insecure is set to false!"
  }
}

resource "errorcheck_is_valid" "certificate_private_key_required" {
  name = "Certificate Private Key Required"
  test = {
    assert        = length(var.certificate_private_key) != 0 || var.client_insecure
    error_message = "The variable certificate_private_key is required if client_insecure is set to false!"
  }
}

resource "errorcheck_is_valid" "certificate_validation" {
  name = "Certificate Validation"
  test = {
    assert        = length(join("\n", regexall("(?m)^-----BEGIN CERTIFICATE-----(?s:.*?)^-----END CERTIFICATE-----", var.certificate))) > 0 || var.client_insecure
    error_message = "The certificate is in wrong format. Please ensure that the certificate supplied is in PEM format!"
  }
  depends_on = [errorcheck_is_valid.certificate_required]
}

resource "errorcheck_is_valid" "certificate_private_key_validation" {
  name = "Certificate Private Key Validation"
  test = {
    assert        = length(join("\n", regexall("(?m)^-----BEGIN.*?PRIVATE KEY-----(?s:.*?)^-----END.*?PRIVATE KEY-----", var.certificate_private_key))) > 0 || var.client_insecure
    error_message = "The private key is in wrong format. Please ensure that the certificate supplied is in PEM format!"
  }
  depends_on = [errorcheck_is_valid.certificate_private_key_required]
}

variable "domain" {
  type        = string
  description = "Domain name to create DNS and WAF resources for."
}

variable "server_addresses" {
  type        = set(string)
  description = "Set of destination endpoint(s) external IP address(es) and ports they are listening on in format <ip_addr>:<port>"
}

variable "server_insecure" {
  type        = bool
  description = "Use HTTP (insecure) protocol between WAF and destination endpoint(s). (default: false)."
  default     = false
}

variable "client_insecure" {
  type        = bool
  description = "Use HTTP (insecure) protocol between WAF and client. (default: false)."
  default     = false
}

variable "tls_version" {
  type        = string
  description = "TLS version to enforce on client. Accepted values are \"TLS v1.1\" and \"TLS v1.2\". (default: TLS v1.2)"
  default     = "TLS v1.2"
  validation {
    condition     = contains(["TLS v1.1", "TLS v1.2"], var.tls_version)
    error_message = "Allowed values for tls_version are \"TLS v1.1\" and \"TLS v1.2\"."
  }
}

variable "tls_cipher" {
  type        = string
  description = "Cipher suite to use with TLS. Accepted values are \"cipher_default\", \"cipher_1\", \"cipher_2\" and \"cipher_3\". (default: cipher_1)"
  default     = "cipher_1"
  validation {
    condition     = contains(["cipher_default", "cipher_1", "cipher_2", "cipher_3"], var.tls_cipher)
    error_message = "Allowed values for tls_cipher are \"cipher_default\", \"cipher_1\", \"cipher_2\" and \"cipher_3\"."
  }
}

variable "dns_zone_id" {
  type        = string
  description = "OTC DNS zone to create the WAF CNAME records in."
}

variable "waf_policy_id" {
  type        = string
  description = "WAF policy ID to associate with the domains. (default: OTC will create a default policy)"
  default     = null
}