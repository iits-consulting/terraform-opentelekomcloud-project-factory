data "opentelekomcloud_identity_project_v3" "current" {}

variable "name" {
  type        = string
  description = "CCE cluster name"
}

variable "tags" {
  type        = map(any)
  description = "Common tag set for CCE resources"
  default     = {}
}

variable "cluster_vpc_id" {
  type        = string
  description = "VPC id where the cluster will be created in"
}
variable "cluster_subnet_id" {
  type        = string
  description = "Subnet network id where the cluster will be created in"
}

variable "cluster_version" {
  type        = string
  description = "CCE cluster version."
  default     = "v1.30"
}

variable "cluster_size" {
  type        = string
  description = "Size of the cluster: small, medium, large"
  default     = "small"
  validation {
    condition     = contains(["small", "medium", "large"], lower(var.cluster_size))
    error_message = "Allowed values for cluster_size are \"small\", \"medium\" and \"large\"."
  }
}

variable "cluster_type" {
  type        = string
  description = "Cluster type: VirtualMachine or BareMetal"
  default     = "VirtualMachine"

  validation {
    condition     = contains(["VirtualMachine", "BareMetal"], var.cluster_type == null ? "VirtualMachine" : var.cluster_type)
    error_message = "Allowed values for cluster_type are \"VirtualMachine\" and \"BareMetal\"."
  }
}

variable "cluster_container_network_type" {
  type        = string
  description = "Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  default     = ""
}

resource "errorcheck_is_valid" "container_network_type" {
  name = "Check if container_network_type is set up correctly."
  test = {
    assert = (
      length(var.cluster_container_network_type) == 0 ||
      (try(contains(["vpc-router", "overlay_l2"], var.cluster_container_network_type), false) && (var.cluster_type == "VirtualMachine" || var.cluster_type == null)) ||
      (try(contains(["underlay_ipvlan"], var.cluster_container_network_type), false) && var.cluster_type == "BareMetal")
    )
    error_message = "Allowed values for container_network_type are \"vpc-router\" and \"overlay_l2\" for VirtualMachine Clusters; and \"underlay_ipvlan\" for BareMetal Clusters."
  }
}

variable "cluster_enable_volume_encryption" {
  description = "System and data disks encryption of master nodes. Changing this parameter will create a new cluster resource."
  default     = true
  type        = bool
}

variable "cluster_container_cidr" {
  type        = string
  description = "Kubernetes pod network CIDR range"
  default     = "172.16.0.0/16"
}

variable "cluster_service_cidr" {
  type        = string
  description = "Kubernetes service network CIDR range"
  default     = "10.247.0.0/16"
}

variable "cluster_public_access" {
  type        = bool
  description = "Bind a public IP to the CLuster to make it public available"
  default     = true
}

variable "cluster_high_availability" {
  type        = bool
  description = "Create the cluster in highly available mode"
  default     = false
}

variable "cluster_enable_scaling" {
  type        = bool
  description = "Enable autoscaling of the cluster"
  default     = false
}

variable "cluster_install_icagent" {
  type        = bool
  description = "Install icagent for logging and metrics via AOM"
  default     = false
}

locals {
  //"Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  cluster_container_network_type = length(var.cluster_container_network_type) > 0 ? var.cluster_container_network_type : var.cluster_type == "VirtualMachine" ? "vpc-router" : "underlay_ipvlan"
}

variable "node_availability_zones" {
  type        = set(string)
  description = "Availability zones for the node pools. Providing multiple availability zones creates one node pool in each zone."
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
  description = "Operating system of worker nodes: EulerOS 2.9 or HCE 2.0"
  default     = "HCE 2.0"
}

variable "node_container_runtime" {
  type        = string
  description = "The container runtime to use. Must be set to either containerd or docker."
  default     = "containerd"
  validation {
    condition     = contains(["containerd", "docker"], var.node_container_runtime)
    error_message = "Allowed values for node_container_runtime are either \"containerd\" or \"docker\"."
  }
}

variable "node_storage_type" {
  type        = string
  description = "Type of node storage SATA, SAS or SSD"
  default     = "SATA"
}

variable "node_storage_size" {
  type        = number
  description = "Size of the node system disk in GB"
  default     = 100
}

variable "node_storage_encryption_enabled" {
  type        = bool
  description = "Enable OTC KMS volume encryption for the node pool volumes."
  default     = true
}

variable "node_storage_encryption_kms_key_name" {
  type        = string
  description = "If KMS volume encryption is enabled, specify a name of an existing kms key. Setting this disables the creation of a new kms key."
  default     = null
}

variable "node_postinstall" {
  type        = string
  description = "Post install script for the cluster ECS node pool."
  default     = ""
}

variable "node_taints" {
  type = list(object({
    effect = string
    key    = string
    value  = string
  }))
  description = "Node taints for the node pool"
  default     = []
}

variable "node_k8s_tags" {
  default     = {}
  description = "(Optional, Map) Tags of a Kubernetes node, key/value pair format."
  type        = map(string)
}

variable "autoscaler_node_max" {
  type        = number
  description = "Maximum limit of servers to create"
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

variable "autoscaler_version" {
  type        = string
  description = "Version of the Autoscaler Addon Template"
  default     = "latest"
}

variable "metrics_server_version" {
  type        = string
  description = "Version of the Metrics Server Addon Template"
  default     = "latest"
}

variable "cluster_authentication_mode" {
  type        = string
  description = "Authentication mode of the Cluster. Either rbac or authenticating_proxy"
  default     = "rbac"
}

variable "cluster_authenticating_proxy_ca" {
  type        = string
  description = "X509 CA certificate configured in authenticating_proxy mode. The maximum size of the certificate is 1 MB."
  default     = null
}

variable "cluster_authenticating_proxy_cert" {
  type        = string
  description = "Client certificate issued by the X509 CA certificate configured in authenticating_proxy mode."
  default     = null
}

variable "cluster_authenticating_proxy_private_key" {
  type        = string
  description = "Private key of the client certificate issued by the X509 CA certificate configured in authenticating_proxy mode."
  default     = null
}

resource "errorcheck_is_valid" "cluster_authenticating_proxy_config" {
  name = "Check if cluster_authenticating_proxy is set up correctly."
  test = {
    assert = (
      var.cluster_authentication_mode == "authenticating_proxy" ||
      length(compact([var.cluster_authenticating_proxy_ca, var.cluster_authenticating_proxy_cert, var.cluster_authenticating_proxy_private_key])) < 3
    )

    error_message = "Variables \"cluster_authenticating_proxy_ca\", \"cluster_authenticating_proxy_cert\" and \"cluster_authenticating_proxy_private_key\" when \"cluster_authentication_mode\" is set to \"authenticating_proxy\"!"
  }
}
