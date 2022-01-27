variable "bucket_name" {
  type        = string
  description = "Bucket name to read secrets from. Make sure the provider for this module has access to both the bucket and the KMS resource in case of encryption."
}

variable "required_secrets" {
  type        = list(string)
  description = "Optional list of top level secret names (keys) to exist within the file. Any missing keys will result in an error."
  default     = []
}

variable "bucket_object_key" {
  type        = string
  description = "Path and name to the object within the bucket."
}
