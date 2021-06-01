variable "context_name" {
  type    = string
}
variable "stage_name" {}
variable "vpc_flavor_id" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "key_pair_id" {}
variable "nodes" {
  type = map(string)
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
variable "availability_zone" {
  default = "eu-de-01"
  type    = string
}
variable "container_network_type" {
  default = "vpc-router"
  type    = string
}
variable "node_name_prefix" {
  default = "node"
  type    = string
}
variable "postinstall-script" {
  default = null
  type    = string
}
variable "tags" {
  type    = map(string)
  default = null
}
variable "region" {
  type    = string
  default = "eu-de"
}
variable "public_ip_bandwidth" {
  type        = number
  default     = 300
  description = "The bandwidth size. The value ranges from 1 to 300 Mbit/s."
}