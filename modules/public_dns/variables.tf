variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
  default     = {}
}

variable "domain" {
  type        = string
  description = "The public domain to create public DNS zone for."
}

variable "email" {
  type        = string
  description = "The email address to create public DNS zone with."
}

variable "a_records" {
  type        = map(list(string))
  description = "Map of DNS A records. Maps domains to IPv4 addresses."
  default     = {}
}

variable "cname_records" {
  type        = map(list(string))
  description = "Map of DNS CNAME records. Map one domain to another."
  default     = {}
}

variable "mx_records" {
  type        = map(list(string))
  description = "Map of DNS MX records. Map domains to email servers."
  default     = {}
}

variable "aaaa_records" {
  type        = map(list(string))
  description = "Map of DNS AAAA records. Map domains to IPv6 addresses."
  default     = {}
}

variable "txt_records" {
  type        = map(list(string))
  description = "Map of DNS TXT records. Specify text records."
  default     = {}
}

variable "srv_records" {
  type        = map(list(string))
  description = "Map of DNS SRV records. Record servers providing specific services."
  default     = {}
}

variable "ns_records" {
  type        = map(list(string))
  description = "Map of DNS NS records. Delegate subdomains to other name servers."
  default     = {}
}

variable "caa_records" {
  type        = map(list(string))
  description = "Map of DNS CAA records. Grant certificate issuing permissions to CAs."
  default     = {}
}
