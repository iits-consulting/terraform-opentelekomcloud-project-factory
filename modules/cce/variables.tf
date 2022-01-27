variable "context_name" {
  type        = string
  description = "Short descriptive, readable label of the project you are working on. Is utilized as a part of resource names."
}
variable "stage_name" {
  default     = "dev"
  type        = string
  description = "Utilized to distinguish separate, but mostly equal environments within the same project. Usually dev, test, qa, prod."
}

variable "cce_flavor_id" {
  default     = "cce.s1.small"
  description = "See https://open-telekom-cloud.com/en/prices/price-calculator for information about cce flavors and associated prices."
}

variable "subnet_id" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "key_pair_id" {}
variable "nodes" {
  type        = list(string)
  description = "List of node specs like [s3.xlarge.2, s3.xlarge.4]. The number of entries in the list determines the number of worker nodes in the cluster. See https://open-telekom-cloud.com/en/prices/price-calculator for information about virtual machine flavors (ECS) and associated prices."
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
  type        = map(string)
  default     = null
  description = ""
}
variable "region" {
  type        = string
  default     = "eu-de"
  description = "Region in which to create the cloud resources."
}
variable "public_ip_bandwidth" {
  type        = number
  default     = 300
  description = "The bandwidth size. The value ranges from 1 to 1000 Mbit/s."
}
variable "cce_version" {
  type        = string
  default     = null
  description = "Set this to a specific kubernetes version if you do not want the newest one."
}

variable "cce_authentication_mode" {
  default = "rbac"
}

variable "node_data_encryption_key_id" {
  type        = string
  default     = null
  description = "KMS Key ID for the encryption of CCE node data volumes."
}

variable "addon_metric_server_version" {
  type        = string
  default     = "1.0.6"
  description = "Version for Metric-Server addon."
}
