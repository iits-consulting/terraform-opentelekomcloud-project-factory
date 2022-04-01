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
  description = "The public domain to create private DNS zone for."
}

variable "a_records" {
  type        = map(list(string))
  description = "Map of DNS A records."
  default     = {}
}

variable "cname_records" {
  type        = map(list(string))
  description = "Map of DNS CNAME records."
  default     = {}
}

variable "mx_records" {
  type        = map(list(string))
  description = "Map of DNS MX records."
  default     = {}
}

variable "aaaa_records" {
  type        = map(list(string))
  description = "Map of DNS AAAA records."
  default     = {}
}

variable "txt_records" {
  type        = map(list(string))
  description = "Map of DNS TXT records."
  default     = {}
}

variable "ptr_records" {
  type        = map(list(string))
  description = "Map of DNS PTR records."
  default     = {}
}

variable "srv_records" {
  type        = map(list(string))
  description = "Map of DNS SRV records."
  default     = {}
}
