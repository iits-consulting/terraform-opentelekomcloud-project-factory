variable "name" {
  type        = string
  description = "CCE cluster name"
}

variable "tags" {
  type        = map(any)
  description = "Common tag set for CCE resources"
  default     = {}
}

variable "cluster_config_vpc_id" {
  type        = string
  description = "VPC id where the cluster will be created in"
}
variable "cluster_config_subnet_id" {
  type        = string
  description = "Subnet network id where the cluster will be created in"
}
variable "cluster_config_cluster_version" {
  type        = string
  description = "CCE cluster version."
  default     = "v1.23"
}
variable "cluster_config_cluster_size" {
  type        = string
  description = "Size of the cluster: small, medium, large (default: small)"
  default     = "small"
  validation {
    condition     = contains(["small", "medium", "large"], lower(var.cluster_config_cluster_size))
    error_message = "Allowed values for cluster_size are \"small\", \"medium\" and \"large\"."
  }
}
variable "cluster_config_cluster_type" {
  type        = string
  description = "Cluster type: VirtualMachine or BareMetal (default: VirtualMachine)"
  default     = "VirtualMachine"

  validation {
    condition     = contains(["VirtualMachine", "BareMetal"], var.cluster_config_cluster_type == null ? "VirtualMachine" : var.cluster_config_cluster_type)
    error_message = "Allowed values for cluster_type are \"VirtualMachine\" and \"BareMetal\"."
  }
}
variable "cluster_config_container_network_type" {
  type        = string
  description = "Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  default     = ""
}
resource "errorcheck_is_valid" "container_network_type" {
  name = "Check if container_network_type is set up correctly."
  test = {
    assert = (
      var.cluster_config_container_network_type == null ||
      (try(contains(["vpc-router", "overlay_l2"], var.cluster_config_container_network_type), false) && (var.cluster_config_cluster_type == "VirtualMachine" || var.cluster_config_cluster_type == null)) ||
      (try(contains(["underlay_ipvlan"], var.cluster_config_container_network_type), false) && var.cluster_config_cluster_type == "BareMetal") ||
      (try(contains([""], var.cluster_config_container_network_type), false))
    )
    error_message = "Allowed values for container_network_type are \"vpc-router\" and \"overlay_l2\" for VirtualMachine Clusters; and \"underlay_ipvlan\" for BareMetal Clusters."
  }
}

variable "cluster_config_container_cidr" {
  type        = string
  description = "Kubernetes pod network CIDR range (default: 172.16.0.0/16)"
  default     = "172.16.0.0/16"
}
variable "cluster_config_service_cidr" {
  type        = string
  description = "Kubernetes service network CIDR range (default: 10.247.0.0/16)"
  default     = "10.247.0.0/16"
}
variable "cluster_config_public_cluster" {
  type        = bool
  description = "Bind a public IP to the CLuster to make it public available (default: true)"
  default     = true
}
variable "cluster_config_high_availability" {
  type        = bool
  description = "Create the cluster in highly available mode (default: false)"
  default     = false
}
variable "cluster_config_enable_scaling" {
  type        = bool
  description = "Enable autoscaling of the cluster (default: false)"
  default     = false
}
variable "cluster_config_install_icagent" {
  type        = bool
  description = "install icagent for logging and metrics (default: false)"
  default     = false
}

locals {
  //"Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  cluster_config_container_network_type = length(var.cluster_config_container_network_type) > 0 ? var.cluster_config_container_network_type : var.cluster_config_cluster_type == "VirtualMachine" ? "vpc-router" : "underlay_ipvlan"
}

variable "node_config_availability_zones" {
  type        = list(string)
  description = "Availability zones for the node pools. Providing multiple availability zones creates one node pool in each zone."
}

variable "node_config_node_count" {
  type        = number
  description = "Number of nodes to create"
}

variable "node_config_node_flavor" {
  type        = string
  description = "Node specifications in otc flavor format"
}

variable "node_config_node_os" {
  type        = string
  description = "Operating system of worker nodes: EulerOS 2.5 or CentOS 7.7 (default: EulerOS 2.9)"
  default     = "EulerOS 2.9"
}

variable "node_config_node_storage_type" {
  type        = string
  description = "Type of node storage SATA, SAS or SSD (default: SATA)"
  default     = "SATA"
}

variable "node_config_node_storage_size" {
  type        = number
  description = "Size of the node system disk in GB (default: 100)"
  default     = 100
}

variable "node_config_node_storage_encryption_enabled" {
  type        = bool
  description = "Enable OTC KMS volume encryption for the node pool volumes. (default: false)"
  default     = false
}

variable "node_config_node_postinstall" {
  type        = string
  description = "Post install script for the cluster ECS node pool."
  default     = ""
}

variable "autoscaling_config_nodes_max" {
  type        = number
  description = "Maximum limit of servers to create (default: 10)"
  default     = 10
}

variable "autoscaling_config_nodes_min" {
  type        = number
  description = "Lower bound of servers to always keep (default: <node_count>)"
  default     = null
}

variable "autoscaling_config_cpu_upper_bound" {
  type        = number
  description = "Cpu utilization upper bound for upscaling (default: 0.8)"
  default     = 0.8
}

variable "autoscaling_config_mem_upper_bound" {
  type        = number
  description = "Memory utilization upper bound for upscaling (default: 0.8)"
  default     = 0.8
}

variable "autoscaling_config_lower_bound" {
  type        = number
  description = "Memory AND cpu utilization lower bound for downscaling (default: 0.2)"
  default     = 0.2
}

variable "autoscaler_version" {
  type        = string
  description = "Version of the Autoscaler Addon Template (default: 1.23.6)"
  default     = "1.23.6"
}

locals {
  // Lower bound of servers to always keep (default: <node_count>)
  autoscaling_config_nodes_min = var.node_config_node_count != null ? var.node_config_node_count : null
}

variable "metrics_server_version" {
  type        = string
  description = "Version of the Metrics Server Addon Template (default: 1.2.1)"
  default     = "1.2.1"
}
