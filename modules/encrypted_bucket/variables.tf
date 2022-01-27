variable "bucket_name" {
  type = string
}

variable "secrets" {
  type = map(string)
}

variable "bucket_object_name" {
  type = string
  default = "terraform-secrets"
}

variable "tags" {
  type = map(string)
  default = null
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