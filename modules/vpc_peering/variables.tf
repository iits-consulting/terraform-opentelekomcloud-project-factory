variable "name" {
  description = "VPC peering connection name."
}

variable "vpc_id" {
  description = "VPC id to create the peering from."
  type        = string
}

variable "peer_vpc_id" {
  description = "Peer VPC id to create the peering to."
  type        = string
}

variable "cidr" {
  description = "CIDR ranges that will be routed from the peer VPC."
  type        = set(string)
}

variable "peer_cidr" {
  description = "CIDR ranges that will be routed to the peer VPC."
  type        = set(string)
}
