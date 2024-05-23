data "opentelekomcloud_lb_flavor_v3" "layer4_flavor" {
  count = length(var.layer4_flavor) == 0 ? 0 : 1
  name  = var.layer4_flavor
}

data "opentelekomcloud_lb_flavor_v3" "layer7_flavor" {
  count = length(var.layer7_flavor) == 0 ? 0 : 1
  name  = var.layer7_flavor
}

resource "opentelekomcloud_lb_loadbalancer_v3" "elb" {
  name        = "${var.name_prefix}-ELB"
  description = "Dedicated ELB instance with public IP."
  subnet_id   = var.subnet_id
  network_ids = var.network_ids

  l4_flavor = length(var.layer4_flavor) == 0 ? null : data.opentelekomcloud_lb_flavor_v3.layer4_flavor[0].id
  l7_flavor = length(var.layer7_flavor) == 0 ? null : data.opentelekomcloud_lb_flavor_v3.layer7_flavor[0].id

  availability_zones = var.availability_zones
  public_ip {
    id = opentelekomcloud_vpc_eip_v1.ingress_eip.id
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [router_id]
  }
}

resource "opentelekomcloud_vpc_eip_v1" "ingress_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "${var.name_prefix}-ELB"
    share_type  = "PER"
    size        = var.bandwidth
  }
  publicip {
    type = "5_bgp"
  }
  tags = var.tags
}
