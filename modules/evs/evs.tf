resource "random_id" "volume_kms_id" {
  byte_length = 4
}

resource "opentelekomcloud_kms_key_v1" "volume_kms_key" {
  key_alias       = "${var.kms_key_prefix}-evs-key-${random_id.volume_kms_id.hex}"
  key_description = "Persistent volume encryption key for ${var.kms_key_prefix}"
  pending_days    = 7
  is_enabled      = "true"
}

resource "opentelekomcloud_evs_volume_v3" "evs_volumes" {
  count             = length(var.volume_names)
  name              = var.volume_names[count.index]
  description       = "${var.volume_names[count.index]} EVS volume"
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  size              = var.spec.size
  volume_type       = var.spec.volume_type
  device_type       = var.spec.device_type
  tags              = var.tags
  kms_id            = opentelekomcloud_kms_key_v1.volume_kms_key.id
}

output "volumes" {
  value = { for volume in opentelekomcloud_evs_volume_v3.evs_volumes : volume.name => volume }
}
