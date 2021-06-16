variable "vpc_cidr" {}
variable "vpc_name" {}
variable "stage_name" {
  default     = "dev"
  type        = string
  description = "Utilized to distinguish separate, but mostly equal environments within the same project. Usually dev, test, qa, prod."
}
variable "vpc_subnet_cidr" {}
variable "vpc_subnet_gateway_ip" {
  default     = null
  description = "Can be set to specify the exact IP address of the gateway. By default it will just use the first IP address in the subnet cidr"
}
variable "tags" {
  default = null
  type    = map(string)
}
variable "region" {}

locals {
  vpc_subnet_gateway_ip = var.vpc_subnet_gateway_ip == null ? cidrhost(var.vpc_cidr, 1) : var.vpc_subnet_gateway_ip
}

resource "opentelekomcloud_vpc_v1" "vpc" {
  name   = var.vpc_name
  cidr   = var.vpc_cidr
  region = var.region
  shared = true
  tags   = var.tags
}

resource "opentelekomcloud_vpc_subnet_v1" "subnet" {
  name          = "subnet-${var.stage_name}"
  cidr          = var.vpc_subnet_cidr
  vpc_id        = opentelekomcloud_vpc_v1.vpc.id
  gateway_ip    = local.vpc_subnet_gateway_ip
  region        = var.region
  dhcp_enable   = true
  primary_dns   = "100.125.4.25"
  secondary_dns = "8.8.8.8"
  tags          = var.tags
}

output "vpc_id" {
  value = opentelekomcloud_vpc_v1.vpc.id
}
output "subnet_id" {
  value = opentelekomcloud_vpc_subnet_v1.subnet.subnet_id
}
output "subnet_network_id" {
  value = opentelekomcloud_vpc_subnet_v1.subnet.id
}