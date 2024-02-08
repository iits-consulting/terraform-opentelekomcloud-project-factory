## Jumphost Module

A module designed to create a cce gpu node pool. 

Usage example:
```hcl
# First you need to create a normal cce cluster
# https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/cce
module "cce" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/cce"
  name   = "mycompany-dev-cluster"

  // Cluster configuration
  cluster_vpc_id            = module.vpc.vpc.id
  cluster_subnet_id         = values(module.vpc.subnets)[0].id
  cluster_high_availability = false
  cluster_enable_scaling    = false
  // Node configuration
  node_availability_zones   = ["eu-de-03"]
  node_count                = 3
  node_flavor               = "s3.large.8"
  node_storage_type         = "SSD"
  node_storage_size         = 100
}

locals {
  gpu_node_config = {
    node_os           = "Ubuntu 22.04"
    node_flavor       = "pi2.2xlarge.4"
    node_storage_type = "SSD"
    node_storage_size = 100
    node_count        = 1
    nodes_max         = 1
    gpu_driver_url    = "https://us.download.nvidia.com/tesla/535.129.03/NVIDIA-Linux-x86_64-535.129.03.run"
  }
}

module "cce_gpu_node_pool" {
  source = "../../modules/cce_gpu_node_pool"

  name_prefix                     = module.cce.cluster_name
  cce_cluster_id                  = module.cce.cluster_id
  node_availability_zones         = ["eu-de-01"]
  node_flavor                     = local.gpu_node_config.node_flavor
  node_storage_type               = local.gpu_node_config.node_storage_type
  node_storage_size               = local.gpu_node_config.node_storage_size
  node_count                      = local.gpu_node_config.node_count
  node_storage_encryption_enabled = false
  autoscaler_node_max             = local.gpu_node_config.nodes_max
  gpu_driver_url                  = local.gpu_node_config.gpu_driver_url

  tags = local.tags
}

```