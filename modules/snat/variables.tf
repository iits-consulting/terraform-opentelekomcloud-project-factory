variable "name_prefix" {
  type        = string
  description = "Prefix for all OTC resource names"
}

variable "tags" {
  type        = map(any)
  description = "Common tag set for OTC resources"
  default     = {}
}

variable "nat_size" {
  type        = string
  description = "The size of the NAT Gateway. Allowed values are \"1\", \"2\", \"3\" and \"4\". (default: \"1\")"
  default     = "1"
  validation {
    condition     = contains(["1", "2", "3", "4"], var.nat_size)
    error_message = "Allowed values for nat_size are \"1\", \"2\", \"3\" and \"4\"."
  }
}

variable "nat_bandwidth" {
  type        = string
  description = "The dedicated bandwidth assigned to the NAT Gateway. (default: 100)"
  default     = 100
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC to create SNAT gateway in."
}

variable "subnet_id" {
  type        = string
  description = "Id of the subnet to place SNAT gateway in."
}

variable "network_ids" {
  type        = set(string)
  description = "List of subnet that will use the SNAT gateway. (default: var.subnet_id)"
  default     = []
}

variable "network_cidrs" {
  type        = set(string)
  description = "List of CIDRs that will use the SNAT gateway. (default: [])"
  default     = []
}
