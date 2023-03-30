variable "bucket_name" {
  type        = string
  description = "Bucket name to read secrets from. Make sure the provider for this module has tennant_name=<region> set"
}

variable "create_bucket" {
  type        = bool
  description = "Create a new bucket or use an existing one. Default: true"
  default     = true
}

variable "enable_versioning" {
  type        = bool
  description = "Disable the versioning for the bucket. Default: true"
  default     = true
}

variable "secrets" {
  type      = map(any)
  sensitive = true
}

variable "bucket_object_key" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = null
}
