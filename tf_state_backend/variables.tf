variable "context" {
  type        = string
  description = "Project name or context"
}

variable "customer" {
  type        = string
  description = "A customer short name indicator (e.g. IITS, DTAG)"
}

variable "domain" {
  type        = string
  description = "OTC domain for the project"
}

variable "region" {
  type        = string
  description = "OTC region for the project: eu-de(default) or eu-nl"
  default     = "eu-de"
  validation {
    condition     = contains(["eu-de", "eu-nl", ""], var.region)
    error_message = "Allowed values for region are \"eu-de\" and \"eu-nl\"."
  }
}

locals {
  context = replace(lower(var.context), "_", "-")
  common_tags = {
    PROJECT  = upper(var.context)
    CUSTOMER = upper(var.customer)
  }
}