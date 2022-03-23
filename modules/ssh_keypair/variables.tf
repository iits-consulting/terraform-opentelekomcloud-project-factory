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

variable "stage_name" {
  default     = "dev"
  type        = string
  description = "Utilized to distinguish separate, but mostly equal environments within the same project. Usually dev, test, qa, prod."
}

locals {
  name = var.name == null ? "keypair-${var.context_name}-${var.stage_name}" : var.name
}