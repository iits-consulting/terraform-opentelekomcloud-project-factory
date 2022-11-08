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
  description = "Availability zone for the node. (default: ...-02 or b depends on the region)"
  default     = 2
}
