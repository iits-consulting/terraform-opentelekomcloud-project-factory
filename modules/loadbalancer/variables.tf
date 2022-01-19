variable "subnet_id" {}
variable "stage_name" {
  default     = "dev"
  type        = string
  description = "Utilized to distinguish separate, but mostly equal environments within the same project. Usually dev, test, qa, prod."
}
variable "context_name" {
  type        = string
  description = "Short descriptive, readable label of the project you are working on. Is utilized as a part of resource names."
}
variable "bandwidth" {
  type        = number
  default     = 300
  description = "The bandwidth size. The value ranges from 1 to 1000 Mbit/s."
}

variable "fixed_ip_address" {
  type        = bool
  description = "When set to true it prevents the `terraform destroy` command from deleting an EIP. It can be useful to avoid adjusting DNS settings too often"
  default     = false
}
