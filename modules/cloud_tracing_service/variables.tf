variable "bucket_name" {
  type = string
}

variable "file_prefix" {
  type    = string
  default = "cts"
}

variable "project_name" {
  type    = string
  default = "eu-de"
}

variable "cts_expiration_days" {
  type        = number
  default     = 180
  description = "How long should the data be preserved within the OBS bucket (in days). default: 180"
}