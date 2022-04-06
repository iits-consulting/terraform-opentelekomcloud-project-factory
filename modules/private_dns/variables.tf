variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate this private DNS zone with."
}

variable "domain" {
  type        = string
  description = "The domain name to create private DNS zone for."
}

variable "a_records" {
  type        = map(list(string))
  description = "Map of DNS A records. Use the same value as <var.domain> for top level domain"
  default     = {}
}

variable "cname_records" {
  type        = map(list(string))
  description = "Map of DNS CNAME records. Use the same value as <var.domain> for top level domain"
  default     = {}
}

variable "mx_records" {
  type        = map(list(string))
  description = "Map of DNS MX records. Use the same value as <var.domain> for top level domain"
  default     = {}
}

variable "aaaa_records" {
  type        = map(list(string))
  description = "Map of DNS AAAA records. Use the same value as <var.domain> for top level domain"
  default     = {}
}

variable "txt_records" {
  type        = map(list(string))
  description = "Map of DNS TXT records. Use the same value as <var.domain> for top level domain"
  default     = {}
}

variable "ptr_records" {
  type        = map(list(string))
  description = "Map of DNS PTR records. Use the same value as <var.domain> for top level domain"
  default     = {}
}

variable "srv_records" {
  type        = map(list(string))
  description = "Map of DNS SRV records. Use the same value as <var.domain> for top level domain"
  default     = {}
}
