output "elb_id" {
  value = opentelekomcloud_lb_loadbalancer_v3.elb.id
}

output "elb_private_ip" {
  value = opentelekomcloud_lb_loadbalancer_v3.elb.vip_address
}

output "elb_public_ip" {
  value = opentelekomcloud_vpc_eip_v1.ingress_eip.publicip[0].ip_address
}