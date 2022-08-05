resource "opentelekomcloud_lb_loadbalancer_v2" "elb" {
  name          = "elb_${var.context_name}_${var.stage_name}"
  description   = "ELB for project ${var.context_name} (${var.stage_name})"
  vip_subnet_id = var.subnet_id
}

resource "opentelekomcloud_vpc_eip_v1" "ingress_eip" {
  bandwidth {
    charge_mode = "traffic"
    name        = "${var.stage_name}-${var.context_name}-ingress-bandwidth"
    share_type  = "PER"
    size        = var.bandwidth
  }
  publicip {
    type    = "5_bgp"
    port_id = opentelekomcloud_lb_loadbalancer_v2.elb.vip_port_id
  }
}

output "elb_id" {
  value = opentelekomcloud_lb_loadbalancer_v2.elb.id
}

output "elb_private_ip" {
  value = opentelekomcloud_lb_loadbalancer_v2.elb.vip_address
}

output "elb_public_ip" {
  value = opentelekomcloud_vpc_eip_v1.ingress_eip.publicip[0].ip_address
}