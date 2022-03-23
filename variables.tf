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
  default     = null
  type        = string
  description = "Can be set to specify the exact IP address of the gateway. By default it will just use the first IP address in the subnet cidr"
}

variable "cce_node_spec" {
  default     = "s3.large.4"
  type        = string
  description = "See https://open-telekom-cloud.com/en/prices/price-calculator for information about virtual machine flavors (ECS) and associated prices."
}

variable "cce_vpc_flavor_id" {
  default     = "cce.s1.small"
  description = "See https://open-telekom-cloud.com/en/prices/price-calculator for information about vpc flavors and associated prices."
}

variable "tags" {
  type        = map(string)
  description = "Key/Value pairs with the tags to associate with created resources."
  default = {
    managedWith      = "Terraform"
    moduleProvidedBy = "iits"
  }
}

variable "cce_version" {
  type        = string
  default     = "v1.19.8-r0"
  description = "Set this to a specific kubernetes version if you do not want the newest one."
}

variable "cce_autoscaler_version" {
  type        = string
  default     = "1.19.1"
  description = "Set this to a specific kubernetes autoscaler addon version if you do not want the newest one. Has to fit to the CCE version."
}

variable "otc_project_name" {
  type        = string
  default     = "eu-de"
  description = "Name of the Project in which the resources should be created. See IAM -> projects."
}

data "opentelekomcloud_identity_project_v3" "otc_project" {
  name = var.otc_project_name
}

variable "cce_node_count" {
  type        = number
  default     = 2
  description = "The number of worker nodes in the Kubernetes cluster."
}

variable "enable_cce_autocreation" {
  type        = bool
  default     = true
  description = "Controls whether the agency for enabling CCE access for this project should be created. If false and no agency exists, you must access the OTC Console and do this manually by acknowledging the popup that shows up on the CCE page. After this click, the agency is created and you can apply the terraform script."
}

locals {
  node_specs = [for i in range(var.cce_node_count + 1) :
  var.cce_node_spec]
  vpc_subnet_gateway_ip = var.vpc_subnet_gateway_ip == null ? cidrhost(var.vpc_cidr, 1) : var.vpc_subnet_gateway_ip
}