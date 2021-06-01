variable "subnet_id" {}
variable "stage_name" {}
//variable "loadbalancer_ip_address" {}
variable "context_name" {
  default = "otc-customer-success"
  type    = string
}

variable "bandwidth" {
  type        = number
  default     = 300
  description = "The bandwidth size. The value ranges from 1 to 300 Mbit/s."
}

resource "opentelekomcloud_lb_loadbalancer_v2" "elb" {
  name          = "elb_${var.stage_name}"
  description   = "ELB for ${var.stage_name}"
  vip_subnet_id = var.subnet_id

  //  vip_address = var.loadbalancer_ip_address
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

output "elb_public_ip" {
  value = opentelekomcloud_vpc_eip_v1.ingress_eip.publicip[0].ip_address
}