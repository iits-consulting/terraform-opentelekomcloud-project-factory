variable "volume_name" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
  default     = {}
}

variable "size" {
  default     = 500
  description = "Size of the SFS volume in GB. (Default: 500)"
}

variable "share_type" {
  default     = "STANDARD"
  description = "Filesystem type of the SFS volume. (Default: STANDARD)"
}

variable "availability_zone" {
  default = "eu-de-01"
}

variable "vpc_id" {
  description = "VPC id where the SFS volume will be created in."
}

variable "subnet_id" {
  type        = string
  description = "Subnet network id where the SFS volume will be created in."
}

variable "kms_key_id" {
  type        = string
  description = "Existing KMS Key ID if one is already created."
  default     = null
}

variable "kms_key_create" {
  type    = bool
  default = true
}
