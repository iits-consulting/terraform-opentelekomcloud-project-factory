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
  type = string
  description = "VPC id where the cluster will be created in"
}
variable "cluster_config_subnet_id" {
  type = string
  description = "Subnet network id where the cluster will be created in"
}
variable "cluster_config_cluster_version" {
  type = string
  description = "CCE cluster version."
}
variable "cluster_config_cluster_size" {
  type = string
  default = "small"
  description = "Size of the cluster: small, medium, large (default: small)"

  validation {
    condition     = contains(["small", "medium", "large"], lower(var.cluster_config_cluster_size))
    error_message = "Allowed values for cluster_size are \"small\", \"medium\" and \"large\"."
  }
}
variable "cluster_config_container_cidr" {
  type = string
  default = "172.16.0.0/16"
  description = "Kubernetes pod network CIDR range (default: 172.16.0.0/16)"
}
variable "cluster_config_service_cidr" {
  type = string
  default = "10.247.0.0/16"
  description = "Kubernetes service network CIDR range (default: 10.247.0.0/16)"
}
variable "cluster_config_public_cluster" {
  type = bool
  default = true
  description = "Bind a public IP to the CLuster to make it public available (default: true)"
}
variable "cluster_config_high_availability" {
  type = bool
  default = false
  description = "Create the cluster in highly available mode (default: false)"
}
variable "cluster_config_enable_scaling" {
  type = bool
  default = false
  description = "Enable autoscaling of the cluster (default: false)"
}
variable "cluster_config_install_icagent" {
  type = bool
  default = false
  description = "install icagent for logging and metrics (default: false)"
}

# variable "cluster_config" {
#   description = "Cluster configuration parameters"
#   type = object({
#     vpc_id                 = string           // VPC id where the cluster will be created in
#     subnet_id              = string           // Subnet network id where the cluster will be created in
#     cluster_version        = string           // CCE cluster version.
#     cluster_size           = optional(string, "small") // Size of the cluster: small, medium, large (default: small)
#     cluster_type           = optional(string, "VirtualMachine") // Cluster type: VirtualMachine or BareMetal (default: VirtualMachine)
#     container_network_type = optional(string) // Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters
#     container_cidr         = optional(string, "172.16.0.0/16") // Kubernetes pod network CIDR range (default: 172.16.0.0/16)
#     service_cidr           = optional(string, "10.247.0.0/16") // Kubernetes service network CIDR range (default: 10.247.0.0/16)
#     public_cluster         = optional(bool, true)   // Bind a public IP to the CLuster to make it public available (default: true)
#     high_availability      = optional(bool, false)   // Create the cluster in highly available mode (default: false)
#     enable_scaling         = optional(bool, false)   // Enable autoscaling of the cluster (default: false)
#     install_icagent        = optional(bool, false)   // install icagent for logging and metrics (default: false)
#   })
#}
variable "cluster_config" { #NOTE: validation won't work if these are separated
  type        = object({
    cluster_type = optional(string, "VirtualMachine") //Cluster type: VirtualMachine or BareMetal (default: VirtualMachine)
    container_network_type = optional(string, "") //"Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  })
  validation {
    condition     = contains(["VirtualMachine", "BareMetal"], var.cluster_config.cluster_type == null ? "VirtualMachine" : var.cluster_config.cluster_type)
    error_message = "Allowed values for cluster_type are \"VirtualMachine\" and \"BareMetal\"."
  }
  validation {
    condition = (
      var.cluster_config.container_network_type == null ||
      (try(contains(["vpc-router", "overlay_l2"], var.cluster_config.container_network_type), false) && (var.cluster_config.cluster_type == "VirtualMachine" || var.cluster_config.cluster_type == null)) ||
      (try(contains(["underlay_ipvlan"], var.cluster_config.container_network_type), false) && var.cluster_config.cluster_type == "BareMetal") ||
      (try(contains([""],var.cluster_config.container_network_type),false))
    )
    error_message = "Allowed values for container_network_type are \"vpc-router\" and \"overlay_l2\" for VirtualMachine Clusters; and \"underlay_ipvlan\" for BareMetal Clusters."
  }
}

locals {
  //"Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters"
  cluster_config_container_network_type = length(var.cluster_config.container_network_type) > 0 ? var.cluster_config.container_network_type : var.cluster_config.cluster_type == "VirtualMachine" ? "vpc-router" : "underlay_ipvlan"
}

variable "node_config" {
  description = "Cluster node configuration parameters"
  type = object({
    availability_zones              = list(string)     // Availability zones for the node pools. Providing multiple availability zones creates one node pool in each zone.
    node_count                      = number           // Number of nodes to create
    node_flavor                     = string           // Node specifications in otc flavor format
    node_os                         = optional(string, "EulerOS 2.9") // Operating system of worker nodes: EulerOS 2.5 or CentOS 7.7 (default: EulerOS 2.5)
    node_storage_type               = optional(string, "SATA") // Type of node storage SATA, SAS or SSD (default: SATA)
    node_storage_size               = optional(number, 100) // Size of the node system disk in GB (default: 100)
    node_storage_encryption_enabled = optional(bool, false)   // Enable OTC KMS volume encryption for the node pool volumes. (default: false)
    node_postinstall                = optional(string, "") // Post install script for the cluster ECS node pool.
  })
}

variable "autoscaling_config" {
  description = "Autoscaling configuration parameters"
  type = object({
    nodes_max       = optional(number, 10) // Maximum limit of servers to create (default: 10)
    nodes_min       = optional(number) // Lower bound of servers to always keep (default: <node_count>)
    cpu_upper_bound = optional(number, 0.8) // Cpu utilization upper bound for upscaling (default: 0.8)
    mem_upper_bound = optional(number, 0.8) // Memory utilization upper bound for upscaling (default: 0.8)
    lower_bound     = optional(number, 0.2) // Memory AND cpu utilization lower bound for downscaling (default: 0.2)
    version         = optional(string, "1.21.1") // Version of the Autoscaler Addon Template (default: 1.21.1)
  })
}

locals {
  // Lower bound of servers to always keep (default: <node_count>)
  autoscaling_config_nodes_min       = var.node_config.node_count
}

variable "metrics_server_version" {
  type        = string
  description = "Version of the Metrics Server Addon Template (default: 1.1.10)"
  default     = "1.2.1"
}
