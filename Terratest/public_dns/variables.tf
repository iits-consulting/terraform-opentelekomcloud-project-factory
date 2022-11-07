variable "region" {
  type        = string
  description = "OTC region for the project: eu-de(default) or eu-ch2"
  validation {
    condition     = contains(["eu-de", "eu-ch2"], var.region)
    error_message = "Allowed values for region are \"eu-de\" or \"eu-ch\"."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "IP range of the VPC"
}

variable "context" {
  type        = string
  description = "Project context for resource naming and tagging."
}

variable "stage" {
  type        = string
  description = "Project stage for resource naming and tagging."
}

locals {
  prefix = replace(join("-", [lower(var.context), lower(var.stage)]), "_", "-")
  tags = {
    Stage   = var.stage
    Context = var.context
  }
}