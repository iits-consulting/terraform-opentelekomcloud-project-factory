vpc_cidr = "192.168.0.0/16"

cluster_config = {
  enable_scaling    = true
  high_availability = false
  node_flavor       = "s3.large.4"
  node_storage_type = "SSD"
  node_storage_size = 100
  nodes_count       = 2
  nodes_max         = 2
}