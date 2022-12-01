### mandatories
data "opentelekomcloud_identity_project_v3" "current" {}

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

variable "node_storage_encryption_key_name" {
  type        = string
  description = "If jumphost system disk KMS encryption is enabled, use this KMS key name instead of creating a new one."
  default     = null
}

locals {
  node_storage_encryption_enabled = data.opentelekomcloud_identity_project_v3.current.region != "eu-de" ? false : var.node_storage_encryption_enabled
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
  description = "Additional security group names for Jumphost."
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
  type        = string
  description = "Availability zone for the jumphost node."
  default     = ""
}

locals {
  valid_availability_zones = {
    eu-de = toset([
      "eu-de-01",
      "eu-de-02",
      "eu-de-03",
    ])
    eu-nl = toset([
      "eu-nl-01",
      "eu-nl-02",
      "eu-nl-03",
    ])
    eu-ch2 = toset([
      "eu-ch2a",
      "eu-ch2b",
    ])
  }
  region            = data.opentelekomcloud_identity_project_v3.current.region
  availability_zone = length(var.availability_zone) == 0 ? local.region == "eu-ch2" ? "eu-ch2b" : "${local.region}-02" : var.availability_zone
}

resource "errorcheck_is_valid" "availability_zone" {
  name = "Check if availability_zones is set up correctly."
  test = {
    assert        = contains(local.valid_availability_zones[local.region], local.availability_zone)
    error_message = "Please check your availability zones. For ${local.region} the valid az's are ${jsonencode(local.valid_availability_zones[local.region])}"
  }
}
