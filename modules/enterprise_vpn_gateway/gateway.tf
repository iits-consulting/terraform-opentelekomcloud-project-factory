// We bind separately created EIPs instead of using the gateway generated ones so that we can destroy / recreate the gateway without releasing the EIPs.
resource "opentelekomcloud_vpc_eip_v1" "eips" {
  count = var.network_type == "public" ? 2 : 0
  bandwidth {
    name        = "${var.name}-vpn-${count.index == 0 ? "primary" : "secondary"}"
    size        = var.eip_bandwidth
    share_type  = "PER"
    charge_mode = "traffic"
  }
  publicip {
    type = "5_bgp"
  }
  tags = var.tags
}

resource "opentelekomcloud_enterprise_vpn_gateway_v5" "gateway" {
  name               = var.name
  availability_zones = var.availability_zones
  flavor             = var.flavor
  attachment_type    = var.attachment_type
  network_type       = var.network_type
  vpc_id             = var.vpc_id
  local_subnets      = var.local_subnets
  connect_subnet     = var.connect_subnet
  er_id              = var.er_id
  ha_mode            = var.ha_mode
  access_vpc_id      = var.access_vpc_id
  access_subnet_id   = var.access_subnet_id
  asn                = var.asn
  delete_eip         = var.network_type == "public" ? false : null

  dynamic "eip1" {
    for_each = var.network_type == "public" ? [opentelekomcloud_vpc_eip_v1.eips[0].id] : toset([])
    content {
      id = eip1.value
    }
  }
  dynamic "eip2" {
    for_each = var.network_type == "public" ? [opentelekomcloud_vpc_eip_v1.eips[1].id] : toset([])
    content {
      id = eip2.value
    }
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [delete_eip]
  }
}
