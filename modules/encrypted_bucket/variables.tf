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