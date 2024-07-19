data "opentelekomcloud_identity_project_v3" "current" {}

variable "name_prefix" {
  type        = string
  description = "Name prefix for provisioned resources."
}

variable "cce_cluster_id" {
  type        = string
  description = "ID of the existing CCE cluster."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Common tags to add to resources that support them."
}

variable "node_availability_zones" {
  type        = set(string)
  description = "Availability zones for the node pools. Providing multiple availability zones creates one node pool in each zone."
}

variable "node_k8s_tags" {
  default     = {}
  description = "(Optional, Map) Tags of a Kubernetes node, key/value pair format."
  type        = map(string)
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

  region = data.opentelekomcloud_identity_project_v3.current.region
}

resource "errorcheck_is_valid" "node_availability_zones" {
  name = "Check if node_availability_zones are set up correctly."
  test = {
    assert        = length(setsubtract(var.node_availability_zones, local.valid_availability_zones[local.region])) == 0
    error_message = "Please check your availability zones. For ${local.region} the valid az's are ${jsonencode(local.valid_availability_zones[local.region])}"
  }
}

variable "node_count" {
  type        = number
  description = "Number of nodes to create"
}

variable "node_flavor" {
  type        = string
  description = "Node specifications in otc flavor format"
}

variable "node_os" {
  type        = string
  description = "Operating system of worker nodes."
  default     = "EulerOS 2.9"
}

variable "node_container_runtime" {
  type        = string
  description = "The container runtime to use. Must be set to either containerd or docker. (default: containerd)"
  default     = "containerd"
  validation {
    condition     = contains(["containerd", "docker"], var.node_container_runtime)
    error_message = "Allowed values for node_container_runtime are either \"containerd\" or \"docker\"."
  }
}

variable "node_storage_type" {
  type        = string
  description = "Type of node storage SATA, SAS or SSD (default: SATA)"
  default     = "SATA"
}

variable "node_storage_size" {
  type        = number
  description = "Size of the node data disk in GB (default: 100)"
  default     = 100
}

variable "node_storage_encryption_enabled" {
  type        = bool
  description = "Enable OTC KMS volume encryption for the node pool volumes. (default: false)"
  default     = false
}

variable "node_storage_encryption_kms_key_name" {
  type        = string
  description = "If KMS volume encryption is enabled, specify a name of an existing kms key. Setting this disables the creation of a new kms key. (default: null)"
  default     = null
}

variable "node_postinstall" {
  type        = string
  description = "Post install script for the node pool."
  default     = ""
}

variable "node_scaling_enabled" {
  type        = bool
  description = "Enable the scaling for the node pool. Please note that CCE cluster must have autoscaling addon installed. (default: 10)"
  default     = true
}

variable "node_taints" {
  type = list(object({
    effect = string
    key    = string
    value  = string
  }))
  description = "Enable the scaling for the node pool. Please note that CCE cluster must have autoscaling addon installed. (default: 10)"
  default = [{
    effect = "PreferNoSchedule"
    key    = "gpu-node"
    value  = "true"
  }]
}

variable "autoscaler_node_max" {
  type        = number
  description = "Maximum limit of servers to create. (default: 10)"
  default     = 10
}

variable "autoscaler_node_min" {
  type        = number
  description = "Lower bound of servers to always keep (default: <node_count>)"
  default     = null
}

locals {
  // Lower bound of servers to always keep (default: <node_count>)
  autoscaler_node_min = var.autoscaler_node_min == null ? var.node_count : var.autoscaler_node_min
}

variable "gpu_beta_enabled" {
  type        = bool
  description = "Enable GPU Beta Addon"
  default     = true
}

variable "gpu_beta_version" {
  type        = string
  description = "Version of the GPU Beta Addon Template (default: 2.0.46)"
  default     = "2.0.46"
}

variable "gpu_driver_url" {
  type        = string
  description = "Nvidia Driver download URL. Please refer to https://www.nvidia.com/Download/Find.aspx and ensure your driver is matching the GPU in your node flavor."
  default     = ""
}

resource "errorcheck_is_valid" "gpu_driver_url" {
  name = "Check if gpu_driver_url is set if gpu_beta_enabled is true."
  test = {
    assert        = !var.gpu_beta_enabled || var.gpu_driver_url != ""
    error_message = "Parameter gpu_driver_url must be provided if gpu_beta_enabled is true!"
  }
}
