resource "tls_private_key" "jumphost_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "opentelekomcloud_compute_keypair_v2" "jumphost_keypair" {
  name       = "${var.node_name}-keypair"
  public_key = tls_private_key.jumphost_key.public_key_openssh
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


