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
variable "enable_l7" {
  type        = bool
  default     = true
  description = "Enables or disable CC Defense"
}
variable "traffic_pos_id" {
  type        = number
  default     = 9
  description = "Traffic Cleaning Threshold"
}
variable "http_request_pos_id" {
  type        = number
  default     = 12
  description = "HTTP Request Threshold"
}
variable "cleaning_access_pos_id" {
  type        = number
  default     = 8
  description = "Number of Calls"
}
variable "app_type_id" {
  type        = number
  default     = 0
  description = "Currently unknown"
}
variable "anti_ddos_protection" {
  type        = bool
  default     = false
  description = "Controls whether or not to use anti-ddos protection for the EIP address. Disabled because it needs a manual import step first."
}