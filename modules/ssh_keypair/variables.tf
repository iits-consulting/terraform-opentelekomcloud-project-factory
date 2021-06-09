variable "region" {
  type = string
  description = "Region in which to create the cloud resources."
}

variable "context_name" {
  type        = string
  description = "Short descriptive, readable label of the project you are working on. Is utilized as a part of resource names."
}

variable "rsa_bits" {
  default = 2048
  type    = number
}