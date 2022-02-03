output "vpc" {
  value = opentelekomcloud_vpc_v1.vpc
}

output "subnets" {
  value = { for name, subnet in opentelekomcloud_vpc_subnet_v1.subnets : name => {
    id        = subnet.id
    subnet_id = subnet.subnet_id
  } }
}
