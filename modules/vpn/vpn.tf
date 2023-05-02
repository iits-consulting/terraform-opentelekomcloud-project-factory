resource "opentelekomcloud_vpnaas_service_v2" "vpnaas_service" {
  name        = "${var.name}-vpnaas"
  description = "VPN as a service resource for ${var.name}."
  router_id   = var.local_router
}

resource "opentelekomcloud_vpnaas_ike_policy_v2" "ike_policy" {
  name        = "${var.name}-ike-policy"
  description = "IKE policy resource for ${var.name}."

  pfs                  = var.vpn_ike_policy_dh_algorithm
  auth_algorithm       = var.vpn_ike_policy_auth_algorithm
  encryption_algorithm = var.vpn_ike_policy_encryption_algorithm
  ike_version          = "v2"
  lifetime {
    units = "seconds"
    value = var.vpn_ike_policy_lifetime
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "opentelekomcloud_vpnaas_ipsec_policy_v2" "ipsec_policy" {
  name        = "${var.name}-ipsec-policy"
  description = "IPSec policy resource for ${var.name}."

  transform_protocol   = var.vpn_ipsec_policy_protocol
  pfs                  = var.vpn_ipsec_policy_pfs
  auth_algorithm       = var.vpn_ipsec_policy_auth_algorithm
  encryption_algorithm = var.vpn_ipsec_policy_encryption_algorithm
  lifetime {
    units = "seconds"
    value = var.vpn_ipsec_policy_lifetime
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "opentelekomcloud_vpnaas_endpoint_group_v2" "local_peer" {
  name      = "${var.name}-local-peer"
  type      = "cidr"
  endpoints = var.local_subnets
  lifecycle {
    create_before_destroy = true
  }
}

resource "opentelekomcloud_vpnaas_endpoint_group_v2" "remote_peer" {
  name      = "${var.name}-remote-peer"
  type      = "cidr"
  endpoints = var.remote_subnets
  lifecycle {
    create_before_destroy = true
  }
}

resource "opentelekomcloud_vpnaas_site_connection_v2" "tunnel_connection" {
  name           = var.name
  psk            = var.psk
  initiator      = "bi-directional"
  ikepolicy_id   = opentelekomcloud_vpnaas_ike_policy_v2.ike_policy.id
  ipsecpolicy_id = opentelekomcloud_vpnaas_ipsec_policy_v2.ipsec_policy.id
  vpnservice_id  = opentelekomcloud_vpnaas_service_v2.vpnaas_service.id
  admin_state_up = true

  peer_address      = var.remote_gateway
  peer_id           = var.remote_gateway
  peer_ep_group_id  = opentelekomcloud_vpnaas_endpoint_group_v2.remote_peer.id
  local_ep_group_id = opentelekomcloud_vpnaas_endpoint_group_v2.local_peer.id

  // The DPD is not supported according to https://docs.otc.t-systems.com/api/vpn/en_topic_0093011492.html but exists in terraform provider.
  dpd {
    action   = var.dpd ? "restart" : "disabled"
    timeout  = 120 // Default
    interval = 30  // Default
  }
  tags = var.tags
}