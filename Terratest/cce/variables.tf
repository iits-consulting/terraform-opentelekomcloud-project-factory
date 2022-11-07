variable "region" {
  type        = string
  description = "OTC region for the project: eu-de(default) or eu-nl"
  validation {
    condition     = contains(["eu-de", "eu-nl", "eu-ch2"], var.region)
    error_message = "Allowed values for region are \"eu-de\", \"eu-nl\" or \"eu-ch\"."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "IP range of the VPC"
}

variable "cluster_config_enable_scaling" {
  type        = bool
  description = "Enable autoscaling of the cluster"
}

variable "cluster_config_high_availability" {
  type        = bool
  description = "Create the cluster in highly available mode"
}
variable "cluster_config_node_flavor" {
  type        = string
  description = "Node specifications in otc flavor format"
}

variable "cluster_config_node_storage_type" {
  type        = string
  description = "Type of node storage SATA, SAS or SSD"
}

variable "cluster_config_node_storage_size" {
  type        = number
  description = "Size of the node system disk in GB"
}

variable "cluster_config_nodes_count" {
  type        = number
  description = "Number of nodes to create"
}

variable "cluster_config_nodes_max" {
  type        = number
  description = "Maximum limit of servers to create"
}


variable "context" {
  type        = string
  description = "Project context for resource naming and tagging."
}

variable "stage" {
  type        = string
  description = "Project stage for resource naming and tagging."
}
locals {
  prefix = replace(join("-", [lower(var.context), lower(var.stage)]), "_", "-")
  tags = {
    Stage   = var.stage
    Context = var.context
  }
}