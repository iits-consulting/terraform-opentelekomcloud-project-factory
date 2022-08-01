resource "opentelekomcloud_nat_gateway_v2" "nat" {
  name                = "${var.name_prefix}-snat"
  description         = "SNAT gateway ${var.name_prefix}"
  spec                = var.nat_size
  router_id           = var.vpc_id
  internal_network_id = var.subnet_id
}

resource "opentelekomcloud_vpc_eip_v1" "nat_ip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name       = "${var.name_prefix}-snat-bandwidth"
    size       = var.nat_bandwidth
    share_type = "PER"
  }
  tags = var.tags
}

resource "opentelekomcloud_nat_snat_rule_v2" "snat_subnet_default" {
  count          = length(var.network_ids) > 0 ? 0 : 1
  nat_gateway_id = opentelekomcloud_nat_gateway_v2.nat.id
  source_type    = 0
  network_id     = var.subnet_id
  floating_ip_id = opentelekomcloud_vpc_eip_v1.nat_ip.id
}

resource "opentelekomcloud_nat_snat_rule_v2" "snat_subnet" {
  for_each       = var.network_ids
  nat_gateway_id = opentelekomcloud_nat_gateway_v2.nat.id
  source_type    = 0
  network_id     = each.key
  floating_ip_id = opentelekomcloud_vpc_eip_v1.nat_ip.id
}

resource "opentelekomcloud_nat_snat_rule_v2" "snat_cidr" {
  for_each       = var.network_cidrs
  nat_gateway_id = opentelekomcloud_nat_gateway_v2.nat.id
  source_type    = 0
  cidr           = each.key
  floating_ip_id = opentelekomcloud_vpc_eip_v1.nat_ip.id
}
