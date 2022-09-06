resource "opentelekomcloud_networking_secgroup_v2" "db_secgroup" {
  count                = var.sg_secgroup_id == "" ? 1 : 0
  name                 = "${var.name}-secgroup"
  description          = "Database access protection security group."
  delete_default_rules = true
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "db_secgroup_in" {
  count             = var.sg_secgroup_id == "" ? 1 : 0
  direction         = "ingress"
  protocol          = ""
  ethertype         = "IPv4"
  remote_group_id   = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id
  security_group_id = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id

  description = "Allow all communication within database cluster on any port"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "db_secgroup_out" {
  count             = var.sg_secgroup_id == "" ? 1 : 0
  direction         = "egress"
  protocol          = ""
  ethertype         = "IPv4"
  remote_group_id   = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id
  security_group_id = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id

  description = "Allow all communication within database cluster on any port"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "db_allow_out" {
  count             = var.sg_secgroup_id == "" ? 1 : 0
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id

  description = "Allow all outgoing communication from the database instances."
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "db_allow_cidr" {
  for_each          = var.sg_secgroup_id == "" ? length(var.sg_allowed_cidr) == 0 ? toset(["db_subnet_cidr"]) : var.sg_allowed_cidr : toset([])
  direction         = "ingress"
  port_range_min    = local.db_port
  port_range_max    = local.db_port
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = length(var.sg_allowed_cidr) == 0 ? data.opentelekomcloud_vpc_subnet_v1.db_subnet.cidr : each.value
  security_group_id = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id

  description = "Allow db connection from range."
  depends_on  = [data.opentelekomcloud_vpc_subnet_v1.db_subnet]
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "db_allow_secgroup" {
  for_each          = var.sg_secgroup_id == "" ? var.sg_allowed_secgroups : toset([])
  direction         = "ingress"
  port_range_min    = local.db_port
  port_range_max    = local.db_port
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_group_id   = each.value
  security_group_id = opentelekomcloud_networking_secgroup_v2.db_secgroup[0].id

  description = "Allow db connection from security group"
}

