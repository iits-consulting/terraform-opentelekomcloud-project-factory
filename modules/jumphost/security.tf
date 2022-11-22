resource "random_id" "jumphost_storage_encryption_key" {
  count       = local.node_storage_encryption_enabled && var.node_storage_encryption_key_name == null ? 1 : 0
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "jumphost_storage_encryption_key" {
  count           = local.node_storage_encryption_enabled && var.node_storage_encryption_key_name == null ? 1 : 0
  key_alias       = "${var.node_name}-${random_id.jumphost_storage_encryption_key[0].hex}"
  key_description = "${var.node_name} Jumphost Node system volume encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

data "opentelekomcloud_kms_key_v1" "jumphost_storage_existing_encryption_key" {
  count     = local.node_storage_encryption_enabled && var.node_storage_encryption_key_name != null ? 1 : 0
  key_alias = var.node_storage_encryption_key_name
}

resource "opentelekomcloud_networking_secgroup_v2" "jumphost_secgroup" {
  name                 = "${var.node_name}-sg"
  description          = "Administrative access to jumphost via ssh"
  delete_default_rules = true
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "jumphost_secgroup_rule_ssh" {
  for_each = toset(var.trusted_ssh_origins)

  description       = "SSH allowed origins from Internet"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = length(split("/", each.value)) == 2 ? each.value : "${each.value}/32"
  security_group_id = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "jumphost_sg_group_in" {
  direction         = "ingress"
  protocol          = ""
  ethertype         = "IPv4"
  remote_group_id   = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id
  security_group_id = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id

  description = "Allow all communication within jumphost security group on any port."
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "jumphost_sg_group_out" {
  direction         = "egress"
  protocol          = ""
  ethertype         = "IPv4"
  remote_group_id   = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id
  security_group_id = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id

  description = "Allow all communication within jumphost security group on any port."
}


resource "opentelekomcloud_networking_secgroup_rule_v2" "jumphost_secgroup_rule_internet" {
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = opentelekomcloud_networking_secgroup_v2.jumphost_secgroup.id

  description = "Allow all outgoing communication from the jumphost group."
}


