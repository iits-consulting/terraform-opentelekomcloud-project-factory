variable "cce" {
  type = object(
    {
      id     = string,
      name   = string,
      region = string
  })
}

variable "cce_name" {
  type = string
}

variable "availability_zone" {
  default = null
  type    = string
}

variable "node_flavor" {
  default = "s2.xlarge.2"
  type    = string
}

variable "autoscaler_version" {
  default = "1.19.1"
  type    = string
}

variable "ssh_key_pair_id" {}

variable "project_id" {
  type = string
}

variable "postinstall-script" {
  default = null
  type    = string
}
variable "tags" {
  type    = map(string)
  default = null
}

variable "node_pool_name" {
  type    = string
  default = null
}

variable "node_pool_node_count_initial" {
  type    = number
  default = 1
}

variable "node_pool_node_count_min" {
  type    = number
  default = 0
}

variable "node_pool_node_count_max" {
  type    = number
  default = 4
}

variable "scale_down_cooldown_time_minutes" {
  type        = number
  default     = 5
  description = "minutes"
}

variable "nodes_root_volume_size" {
  type        = number
  default     = 100
  description = "gigabytes"
}

variable "nodes_data_volume_size" {
  type        = number
  default     = 100
  description = "gigabytes"
}

variable "nodes_root_volume_type" {
  type    = string
  default = "SATA"
}

variable "nodes_data_volume_type" {
  type    = string
  default = "SATA"
}

variable "nodes_os" {
  default = "EulerOS 2.5"
  type    = string
}

variable "node_data_encryption_key_id" {
  type        = string
  default     = null
  description = "KMS Key ID for the encryption of CCE node data volumes."
}

locals {
  node_pool_name = var.node_pool_name == null ? "${var.cce_name}-node-pool-autoscale" : var.node_pool_name
}
