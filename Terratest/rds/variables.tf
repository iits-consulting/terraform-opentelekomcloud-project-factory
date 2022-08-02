variable "region" {
  type        = string
  description = "OTC region for the project: eu-de(default) or eu-nl"
  validation {
    condition     = contains(["eu-de", "eu-nl", "eu-ch2"], var.region)
    error_message = "Allowed values for region are \"eu-de\", \"eu-nl\" or \"eu-ch\"."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "IP range of the VPC"
}

variable "project_name" {
  type        = string
  description = "The name of the OTC project"
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