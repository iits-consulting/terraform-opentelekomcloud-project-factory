variable "region" {
  type        = string
  description = "Region in which to create the cloud resources."
}

variable "context_name" {
  type        = string
  description = "Short descriptive, readable label of the project you are working on. Is utilized as a part of resource names."
}

variable "rsa_bits" {
  default = 2048
  type    = number
}

variable "name" {
  description = "Name of the keypair (optional). If omitted, the name will be generated from context and stage."
  default     = null
}

locals {
  name = var.name == null ? "keypair-${var.context_name}-${var.stage_name}" : var.name
}