variable "kms_key_id" {
  type = string
}

variable "tf_remote_state_bucket_name" {
  type = string
}

variable "tf_remote_state_bucket_endpoint" {
  type    = string
  default = "obs.eu-de.otc.t-systems.com"
}

variable "region" {
  type    = string
  default = "eu-de"
}

variable "context_name" {
  type        = string
  description = "Short descriptive, readable label of the project you are working on. Is utilized as a part of resource names."
}

variable "stage_name" {
  default     = "dev"
  type        = string
  description = "Utilized to distinguish separate, but mostly equal environments within the same project. Usually dev, test, qa, prod."
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
  type    = string
}

variable "vpc_subnet_gateway_ip" {
  default = "192.168.0.1"
  type    = string
}

variable "cce_node_spec_default" {
  default = "s3.large.4"
  type    = string
}

variable "cce_vpc_flavor_id" {
  default     = "cce.s1.small"
  description = ""
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs with the tags to associate with created resources."
  default     = {
    managedWith = "Terraform"
  }
}

variable cce_version {
  type        = string
  default     = null
  description = "Set this to a specific kubernetes version if you do not want the newest one."
}

variable otc_project_name {
  type        = string
  description = "Name for the Project to create for the resources. See IAM -> projects."
}

data "opentelekomcloud_identity_project_v3" "otc_project" {
  name = var.otc_project_name
}

variable cce_node_count {
  type    = number
  default = 2
}

locals {
  node_specs = {for i in range(var.cce_node_count+1) :
     i => var.cce_node_spec_default}
}

output "cce" {
value = module.cce
}

