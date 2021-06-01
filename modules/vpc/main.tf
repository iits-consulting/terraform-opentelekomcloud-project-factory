variable "vpc_cidr" {}
variable "vpc_name" {}
variable "stage_name" {}
variable "vpc_subnet_cidr" {}
variable "vpc_subnet_gateway_ip" {}
variable "tags" {
  default = null
  type    = map(string)
}

resource "opentelekomcloud_vpc_v1" "vpc" {
  name   = var.vpc_name
  cidr   = var.vpc_cidr
  region = "eu-de"
  shared = true
  tags   = var.tags
}

resource "opentelekomcloud_vpc_subnet_v1" "subnet" {
  name          = "subnet-${var.stage_name}"
  cidr          = var.vpc_subnet_cidr
  vpc_id        = opentelekomcloud_vpc_v1.vpc.id
  gateway_ip    = var.vpc_subnet_gateway_ip
  region        = "eu-de"
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