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
variable "subnet_id" {
  type        = string
  description = "Subnet where the elastic load balancer will be created."
}
