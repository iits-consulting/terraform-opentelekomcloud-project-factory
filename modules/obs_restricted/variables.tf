variable "bucket_name" {
  type        = string
  description = "Bucket name. Make sure the provider for this module has tennant_name=<region> set"
  validation {
    condition     = length("${var.bucket_name}-user") <= 32
    error_message = "The username for the bucket user may only be max 32 characters long."
  }
}

variable "enable_versioning" {
  type        = bool
  description = "Disable the versioning for the bucket. Default: true"
  default     = true
}

variable "region" {
  type        = string
  description = "OTC region for the project: eu-de(default) or eu-nl"
  default     = "eu-de"
  validation {
    condition     = contains(["eu-de", "eu-nl"], var.region)
    error_message = "Allowed values for region are \"eu-de\" and \"eu-nl\"."
  }
}

variable "tags" {
  type    = map(string)
  default = null
}
