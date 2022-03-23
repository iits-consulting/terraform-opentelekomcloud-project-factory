resource "opentelekomcloud_vpc_v1" "vpc" {
  name   = var.name
  cidr   = var.cidr_block
  shared = true
}

resource "opentelekomcloud_vpc_subnet_v1" "subnets" {
  for_each   = var.subnets
  name       = each.key
  vpc_id     = opentelekomcloud_vpc_v1.vpc.id
  cidr       = replace(each.value, "default_cidr", opentelekomcloud_vpc_v1.vpc.cidr)
  gateway_ip = cidrhost(replace(each.value, "default_cidr", opentelekomcloud_vpc_v1.vpc.cidr), 1)
  dns_list   = var.dns_config
}
