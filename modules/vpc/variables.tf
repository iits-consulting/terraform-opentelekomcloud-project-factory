### mandatories
variable "name" {
  type        = string
  description = "Name of the VPC."
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
}

variable "cidr_block" {
  type        = string
  description = "IP range of the VPC"
}

variable "subnets" {
  type        = map(string)
  description = "Subnet names and their cidr ranges."
  default = {
    default-subnet = "default_cidr"
  }
}

variable "dns_config" {
  type        = list(string)
  description = "Common Domain Name Server list for all subnets"
  default = [
    "100.125.4.25",
    "100.125.129.199",
  ]
}

