### mandatories
variable "tags" {
  type        = map(string)
  description = "Jumphost tag set."
  default     = {}
}

variable "subnet_id" {
  description = "Jumphost subnet id for node network configuration"
}

variable "node_name" {
  description = "Jumphost node name."
}

variable "node_flavor" {
  description = "Jumphost node specifications in otc flavor format. (default: s3.medium.2 (3rd generation 1 Core 2GB RAM))"
  default     = "s3.medium.2"
}

variable "node_image_id" {
  description = "Jumphost node image name. Image must exist within the same project as the jumphost node. (default: 9f92079d-9d1b-4832-90c1-a3b4a1c00b9b (Standard_Ubuntu_20.04_latest))"
  default     = "9f92079d-9d1b-4832-90c1-a3b4a1c00b9b"
}

variable "node_storage_type" {
  description = "Jumphost node system disk storage type. Must be one of \"SATA\", \"SAS\", or \"SSD\". (default: SSD)"
  default     = "SSD"
  validation {
    condition     = contains(["SATA", "SAS", "SSD"], var.node_storage_type)
    error_message = "Allowed values for node_storage_type are \"SATA\", \"SAS\", or \"SSD\"."
  }
}

variable "node_storage_size" {
  description = "Jumphost node system disk storage size in GB. (default: 20)"
  type        = number
  default     = 20
}

variable "node_storage_encryption_enabled" {
  description = "Jumphost node system disk storage KMS encryption toggle."
  default     = false
}

variable "node_bandwidth_size" {
  description = "Jumphost node external IP bandwidth size in Mbps. (default: 10)"
  type        = number
  default     = 10
}

variable "trusted_ssh_origins" {
  description = "IP addresses and/or ranges allowed to SSH into the jumphost. (default: [\"0.0.0.0/0\"] (Allow access from all IP addresses.))"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_security_groups" {
  type        = list(string)
  description = "Additional security group IDs for Jumphost."
  default     = []
}

variable "cloud_init" {
  description = "Custom Cloud-init configuration. Cloud-init cloud config format is expected. Only *.yml and *.yaml files will be read."
  default     = ""
}

variable "preserve_host_keys" {
  description = "Enable to generate host keys via terraform and preserve them in the state to keep node identity consistent. (default: true)"
  default     = true
}

variable "availability_zone" {
  type        = number
  description = "Availability zone for the node. (default: ...-03 depends on the region)"
  default     = 3
}

/*  Keep Region separation for blockstorage encryption metadata as long as the region "eu-nl" doesn't support encryption:
 * | Error: error creating OpenTelekomCloud volume: Bad request with: [POST https://evs.eu-nl.otc.t-systems.com/v2/cc89cd47e1964cd6b079a80d63c124f2/volumes], error message: {"badRequest": {"message": "Invalid metadata: Create volume from image, metadata key: __system__encrypted and __system__cmkid not support", "code": 400}}
 * │ 
 * │ with module.jumphost.opentelekomcloud_blockstorage_volume_v2.jumphost_boot_volume,
 * │ on ../../modules/jumphost/node.tf line 20, in resource "opentelekomcloud_blockstorage_volume_v2" "jumphost_boot_volume":
 * │ 20: resource "opentelekomcloud_blockstorage_volume_v2" "jumphost_boot_volume" {
 */

variable "region" {
  type        = string
  description = "Region for metadata separation."
}

locals {
  blockstorage_matedata = {
    eu-de = {
      __system__encrypted = var.node_storage_encryption_enabled ? "1" : "0"
      __system__cmkid     = var.node_storage_encryption_enabled ? opentelekomcloud_kms_key_v1.jumphost_storage_encryption_key[0].id : null
    },
    eu-nl = {
      __system__encrypted = ""
      __system__cmkid     = ""
    }
  }
}