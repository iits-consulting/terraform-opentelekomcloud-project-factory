resource "opentelekomcloud_enterprise_vpn_customer_gateway_v5" "remote_gateway" {
  for_each = var.remote_gateway_addresses
  name     = "${var.name}-${each.key}"
  id_value = each.key
  id_type  = can(cidrnetmask("${each.key}/24")) ? "ip" : "fqdn"
  asn      = can(cidrnetmask("${each.key}/24")) ? var.remote_gateway_asn : 0
  tags     = var.tags
}

resource "random_password" "vpn_psk" {
  count       = length(var.psk) > 0 ? 0 : 1
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "opentelekomcloud_enterprise_vpn_connection_v5" "connection" {
  for_each = merge([for remote_address, remote_gateway in opentelekomcloud_enterprise_vpn_customer_gateway_v5.remote_gateway : {
    for role, otc_addr in local.otc_gateway_ips_selected : "${role}_${remote_address}" => {
      name                = "${role}_${remote_gateway.id_value}"
      remote_gateway_id   = remote_gateway.id
      otc_gateway_ip      = otc_addr
      otc_gateway_ip_role = role
  } }]...)
  name                = data.opentelekomcloud_enterprise_vpn_gateway_v5.otc_gateway.ha_mode == "active-active" ? each.value.name : each.value.otc_gateway_ip_role == "primary" ? "${each.value.name}-master" : "${each.value.name}-slave"
  gateway_id          = var.otc_gateway_id
  gateway_ip          = each.value.otc_gateway_ip
  customer_gateway_id = each.value.remote_gateway_id
  peer_subnets        = var.remote_subnets
  vpn_type            = var.vpn_connection_type
  psk                 = length(var.psk) > 0 ? var.psk : random_password.vpn_psk[0].result
  enable_nqa          = var.enable_nqa
  ha_role             = data.opentelekomcloud_enterprise_vpn_gateway_v5.otc_gateway.ha_mode == "active-active" ? null : each.value.otc_gateway_ip_role == "primary" ? "master" : "slave"

  dynamic "ikepolicy" {
    for_each = var.ike_policy != null ? { policy_config = var.ike_policy } : {}
    content {
      authentication_algorithm   = ikepolicy.value.authentication_algorithm
      authentication_method      = ikepolicy.value.authentication_method
      encryption_algorithm       = ikepolicy.value.encryption_algorithm
      dh_group                   = ikepolicy.value.dh_group
      ike_version                = ikepolicy.value.ike_version
      lifetime_seconds           = ikepolicy.value.lifetime_seconds
      local_id_type              = ikepolicy.value.local_id_type
      local_id                   = ikepolicy.value.local_id
      peer_id_type               = ikepolicy.value.peer_id_type
      peer_id                    = ikepolicy.value.peer_id
      phase_one_negotiation_mode = ikepolicy.value.phase_one_negotiation_mode
      dynamic "dpd" {
        for_each = var.ike_policy_dpd != null ? { dpd_config = var.ike_policy_dpd } : {}
        content {
          timeout  = dpd.value.timeout
          interval = dpd.value.interval
          msg      = dpd.value.msg
        }
      }
    }
  }

  dynamic "ipsecpolicy" {
    for_each = var.ipsec_policy != null ? { policy_config = var.ipsec_policy } : {}
    content {
      authentication_algorithm = ipsecpolicy.value.authentication_algorithm
      encryption_algorithm     = ipsecpolicy.value.encryption_algorithm
      pfs                      = ipsecpolicy.value.pfs
      lifetime_seconds         = ipsecpolicy.value.lifetime_seconds
      encapsulation_mode       = ipsecpolicy.value.encapsulation_mode
      transform_protocol       = ipsecpolicy.value.transform_protocol
    }
  }

  dynamic "policy_rules" {
    for_each = var.policy_rules
    content {
      rule_index  = policy_rules.rule_index
      destination = policy_rules.destination
      source      = policy_rules.source
    }
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [ha_role]
  }
}

resource "opentelekomcloud_enterprise_vpn_connection_monitor_v5" "monitor" {
  for_each      = opentelekomcloud_enterprise_vpn_connection_v5.connection
  connection_id = each.value.id
}
