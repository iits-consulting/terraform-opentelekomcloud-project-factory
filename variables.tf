variable "kms_key_id" {
  type = string
}

variable "tf_remote_state_bucket_name" {
  type = string
}

variable "tf_remote_state_bucket_endpoint" {
  type = string
  default = "obs.eu-de.otc.t-systems.com"
}

variable "region" {
  type = string
  default = "eu-de"
}

variable "context_name" {
  default=string
  description = "Short descriptive, readable label of the project you are working on. Is utilized as a part of resource names."
}

variable "otc_project_name" {
  type        = string
  default     = "eu-de"
  description = "This is the name of the tenant or sub-tenant / project in which the infrastructure should be created, e.g. 'eu-de' or 'eu-de_cce-test'. See projects in IAM."
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
  default = "cce.s1.small"
  description = ""
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs with the tags to associate with created resources."
  default     = {
    managedWith = "Terraform"
  }
}

data "opentelekomcloud_identity_project_v3" "otc_stage_project" {
  name = var.otc_project_name
}

locals {
  node_spec      = {
    1 = var.cce_node_spec_default
    2 = var.cce_node_spec_default
  }
  otc_project_id = data.opentelekomcloud_identity_project_v3.otc_stage_project.id
}