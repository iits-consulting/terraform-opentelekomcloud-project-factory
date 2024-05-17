resource "random_id" "sfs_volume_kms_id" {
  count       = var.kms_key_create ? 1 : 0
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "sfs_volume_kms_key" {
  count           = var.kms_key_create ? 1 : 0
  key_alias       = "${var.volume_name}-SFS-${random_id.sfs_volume_kms_id[0].hex}"
  key_description = "${var.volume_name} SFS volume encryption key"
  pending_days    = 7
  is_enabled      = "true"
}

resource "opentelekomcloud_networking_secgroup_v2" "sfs_volume_sg" {
  name        = "${var.volume_name}-SFS-secgroup"
  description = "${var.volume_name} SFS security group for network accessibility."
}

resource "opentelekomcloud_sfs_turbo_share_v1" "sfs_volume" {
  name              = var.volume_name
  availability_zone = var.availability_zone
  size              = var.size
  share_proto       = "NFS"
  share_type        = var.share_type
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = opentelekomcloud_networking_secgroup_v2.sfs_volume_sg.id
  crypt_key_id      = var.kms_key_create ? opentelekomcloud_kms_key_v1.sfs_volume_kms_key[0].id : var.kms_key_id
}
