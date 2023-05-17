data "opentelekomcloud_identity_project_v3" "peer_project" {
  provider = opentelekomcloud.peer_project
}

resource "opentelekomcloud_vpc_peering_connection_v2" "peering" {
  name           = var.name
  vpc_id         = var.vpc_id
  peer_vpc_id    = var.peer_vpc_id
  peer_tenant_id = data.opentelekomcloud_identity_project_v3.peer_project.id
  provider       = opentelekomcloud.project
}

resource "opentelekomcloud_vpc_peering_connection_accepter_v2" "peering_accept" {
  vpc_peering_connection_id = opentelekomcloud_vpc_peering_connection_v2.peering.id
  accept                    = true
  provider                  = opentelekomcloud.peer_project
}

resource "time_sleep" "wait_accept" {
  create_duration = "10s"
  depends_on      = [opentelekomcloud_vpc_peering_connection_accepter_v2.peering_accept]
}

resource "opentelekomcloud_vpc_route_v2" "to_peer_routes" {
  for_each    = var.peer_cidr
  type        = "peering"
  nexthop     = opentelekomcloud_vpc_peering_connection_v2.peering.id
  destination = each.value
  vpc_id      = var.vpc_id
  depends_on  = [time_sleep.wait_accept]
  provider    = opentelekomcloud.project
}

resource "opentelekomcloud_vpc_route_v2" "from_peer_routes" {
  for_each    = var.cidr
  type        = "peering"
  nexthop     = opentelekomcloud_vpc_peering_connection_v2.peering.id
  destination = each.value
  vpc_id      = var.peer_vpc_id
  depends_on  = [time_sleep.wait_accept]
  provider    = opentelekomcloud.peer_project
}
