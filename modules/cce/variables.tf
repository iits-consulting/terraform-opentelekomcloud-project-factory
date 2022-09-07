variable "name" {
  type        = string
  description = "CCE cluster name"
}

variable "tags" {
  type        = map(any)
  description = "Common tag set for CCE resources"
  default     = null
}

variable "cluster_config" {
  description = "Cluster configuration parameters"
  type = object({
    vpc_id                 = string           // VPC id where the cluster will be created in
    subnet_id              = string           // Subnet network id where the cluster will be created in
    cluster_version        = string           // CCE cluster version.
    cluster_size           = optional(string) // Size of the cluster: small, medium, large (default: small)
    cluster_type           = optional(string) // Cluster type: VirtualMachine or BareMetal (default: VirtualMachine)
    container_network_type = optional(string) // Container network type: vpc-router or overlay_l2 for VirtualMachine Clusters; underlay_ipvlan for BareMetal Clusters
    container_cidr         = optional(string) // Kubernetes pod network CIDR range (default: 172.16.0.0/16)
    service_cidr           = optional(string) // Kubernetes service network CIDR range (default: 10.247.0.0/16)
    public_cluster         = optional(bool)   // Bind a public IP to the CLuster to make it public available (default: true)
    high_availability      = optional(bool)   // Create the cluster in highly available mode (default: false)
    enable_scaling         = optional(bool)   // Enable autoscaling of the cluster (default: false)
    install_icagent        = optional(bool)   // install icagent for logging and metrics (default: false)
  })
  validation {
    condition     = contains(["small", "medium", "large"], lower(var.cluster_config.cluster_size == null ? "small" : var.cluster_config.cluster_size))
    error_message = "Allowed values for cluster_size are \"small\", \"medium\" and \"large\"."
  }
  validation {
    condition     = contains(["VirtualMachine", "BareMetal"], var.cluster_config.cluster_type == null ? "VirtualMachine" : var.cluster_config.cluster_type)
    error_message = "Allowed values for cluster_type are \"VirtualMachine\" and \"BareMetal\"."
  }
  validation {
    condition = (
      var.cluster_config.container_network_type == null ||
      (try(contains(["vpc-router", "overlay_l2"], var.cluster_config.container_network_type), false) && (var.cluster_config.cluster_type == "VirtualMachine" || var.cluster_config.cluster_type == null)) ||
      (try(contains(["underlay_ipvlan"], var.cluster_config.container_network_type), false) && var.cluster_config.cluster_type == "BareMetal")
    )
    error_message = "Allowed values for container_network_type are \"vpc-router\" and \"overlay_l2\" for VirtualMachine Clusters; and \"underlay_ipvlan\" for BareMetal Clusters."
  }
}

locals {
  cluster_config = defaults(var.cluster_config, {
    cluster_type           = "VirtualMachine"
    cluster_size           = "small"
    container_network_type = var.cluster_config.cluster_type == "VirtualMachine" || var.cluster_config.cluster_type == null ? "vpc-router" : "underlay_ipvlan"
    container_cidr         = "172.16.0.0/16"
    service_cidr           = "10.247.0.0/16"
    public_cluster         = true
    high_availability      = false
    enable_scaling         = false
    install_icagent        = false
  })
}

variable "node_config" {
  description = "Cluster node configuration parameters"
  type = object({
    availability_zones              = list(string)     // Availability zones for the node pools. Providing multiple availability zones creates one node pool in each zone.
    node_count                      = number           // Number of nodes to create
    node_flavor                     = string           // Node specifications in otc flavor format
    node_os                         = optional(string) // Operating system of worker nodes: EulerOS 2.5 or CentOS 7.7 (default: EulerOS 2.5)
    node_storage_type               = optional(string) // Type of node storage SATA, SAS or SSD (default: SATA)
    node_storage_size               = optional(number) // Size of the node system disk in GB (default: 100)
    node_storage_encryption_enabled = optional(bool)   // Enable OTC KMS volume encryption for the node pool volumes. (default: false)
    node_postinstall                = optional(string) // Post install script for the cluster ECS node pool.
  })
}

locals {
  node_config = defaults(var.node_config, {
    node_os                         = "EulerOS 2.5"
    node_storage_type               = "SATA"
    node_storage_size               = 100
    node_storage_encryption_enabled = false
    node_postinstall                = ""
  })
}


variable "autoscaling_config" {
  description = "Autoscaling configuration parameters"
  type = object({
    nodes_max       = optional(number) // Maximum limit of servers to create (default: 10)
    nodes_min       = optional(number) // Lower bound of servers to always keep (default: <node_count>)
    cpu_upper_bound = optional(number) // Cpu utilization upper bound for upscaling (default: 0.8)
    mem_upper_bound = optional(number) // Memory utilization upper bound for upscaling (default: 0.8)
    lower_bound     = optional(number) // Memory AND cpu utilization lower bound for downscaling (default: 0.2)
    version         = optional(string) // Version of the Autoscaler Addon Template (default: 1.21.1)
  })
}

locals {
  autoscaling_config = defaults(var.autoscaling_config, {
    nodes_max       = 10
    nodes_min       = local.node_config.node_count
    cpu_upper_bound = 0.8
    mem_upper_bound = 0.8
    lower_bound     = 0.2
    version         = "1.21.1"
  })
}

variable "metrics_server_version" {
  type        = string
  description = "Version of the Metrics Server Addon Template (default: 1.1.10)"
  default     = "1.1.10"
}
