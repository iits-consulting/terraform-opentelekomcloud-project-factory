## CCE gpu node pool Module

A module designed to create a cce gpu node pool. 

Usage example:
```hcl
# First you need to create a normal cce cluster
# https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/cce
module "cce" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/cce"
  name   = "mycompany-dev-cluster"
  
  cluster_vpc_id            = module.vpc.vpc.id
  cluster_subnet_id         = values(module.vpc.subnets)[0].id
  cluster_high_availability = false
  cluster_enable_scaling    = false
  node_availability_zones   = ["eu-de-03"]
  node_count                = 3
  node_flavor               = "s3.large.8"
  node_storage_type         = "SSD"
  node_storage_size         = 100
}

module "cce_gpu_node_pool" {
  source = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/cce_gpu_node_pool"

  name_prefix                     = module.cce.cluster_name
  cce_cluster_id                  = module.cce.cluster_id
  node_availability_zones         = ["eu-de-03"]
  node_flavor                     = "pi2.2xlarge.4"
  node_storage_type               = "SSD"
  node_storage_size               = 100
  node_count                      = 1
  autoscaler_node_max             = 1
  gpu_driver_url                  = "https://us.download.nvidia.com/tesla/535.129.03/NVIDIA-Linux-x86_64-535.129.03.run"
}

```


Notes
- container_network_type of the cce needs to be _vpc-router_
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.gpu_driver_url](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [errorcheck_is_valid.node_availability_zones](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [opentelekomcloud_cce_addon_v3.gpu](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/cce_addon_v3) | resource |
| [opentelekomcloud_cce_node_pool_v3.cluster_node_pool](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/cce_node_pool_v3) | resource |
| [opentelekomcloud_compute_keypair_v2.cluster_keypair](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/compute_keypair_v2) | resource |
| [opentelekomcloud_kms_key_v1.node_storage_encryption_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [random_id.cluster_keypair_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.cluster_keypair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [opentelekomcloud_cce_addon_template_v3.gpu](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/cce_addon_template_v3) | data source |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_kms_key_v1.node_storage_encryption_existing_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/kms_key_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cce_cluster_id"></a> [cce\_cluster\_id](#input\_cce\_cluster\_id) | ID of the existing CCE cluster. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for provisioned resources. | `string` | n/a | yes |
| <a name="input_node_availability_zones"></a> [node\_availability\_zones](#input\_node\_availability\_zones) | Availability zones for the node pools. Providing multiple availability zones creates one node pool in each zone. | `set(string)` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of nodes to create | `number` | n/a | yes |
| <a name="input_node_flavor"></a> [node\_flavor](#input\_node\_flavor) | Node specifications in otc flavor format | `string` | n/a | yes |
| <a name="input_autoscaler_node_max"></a> [autoscaler\_node\_max](#input\_autoscaler\_node\_max) | Maximum limit of servers to create. (default: 10) | `number` | `10` | no |
| <a name="input_autoscaler_node_min"></a> [autoscaler\_node\_min](#input\_autoscaler\_node\_min) | Lower bound of servers to always keep (default: <node\_count>) | `number` | `null` | no |
| <a name="input_gpu_beta_enabled"></a> [gpu\_beta\_enabled](#input\_gpu\_beta\_enabled) | Enable GPU Beta Addon | `bool` | `true` | no |
| <a name="input_gpu_beta_version"></a> [gpu\_beta\_version](#input\_gpu\_beta\_version) | Version of the GPU Beta Addon Template (default: 2.0.46) | `string` | `"2.0.46"` | no |
| <a name="input_gpu_driver_url"></a> [gpu\_driver\_url](#input\_gpu\_driver\_url) | Nvidia Driver download URL. Please refer to https://www.nvidia.com/Download/Find.aspx and ensure your driver is matching the GPU in your node flavor. | `string` | `""` | no |
| <a name="input_node_container_runtime"></a> [node\_container\_runtime](#input\_node\_container\_runtime) | The container runtime to use. Must be set to either containerd or docker. (default: containerd) | `string` | `"containerd"` | no |
| <a name="input_node_k8s_tags"></a> [node\_k8s\_tags](#input\_node\_k8s\_tags) | (Optional, Map) Tags of a Kubernetes node, key/value pair format. | `map(string)` | `{}` | no |
| <a name="input_node_os"></a> [node\_os](#input\_node\_os) | Operating system of worker nodes. | `string` | `"EulerOS 2.9"` | no |
| <a name="input_node_postinstall"></a> [node\_postinstall](#input\_node\_postinstall) | Post install script for the node pool. | `string` | `""` | no |
| <a name="input_node_scaling_enabled"></a> [node\_scaling\_enabled](#input\_node\_scaling\_enabled) | Enable the scaling for the node pool. Please note that CCE cluster must have autoscaling addon installed. (default: 10) | `bool` | `true` | no |
| <a name="input_node_storage_encryption_enabled"></a> [node\_storage\_encryption\_enabled](#input\_node\_storage\_encryption\_enabled) | Enable OTC KMS volume encryption for the node pool volumes. (default: false) | `bool` | `false` | no |
| <a name="input_node_storage_encryption_kms_key_name"></a> [node\_storage\_encryption\_kms\_key\_name](#input\_node\_storage\_encryption\_kms\_key\_name) | If KMS volume encryption is enabled, specify a name of an existing kms key. Setting this disables the creation of a new kms key. (default: null) | `string` | `null` | no |
| <a name="input_node_storage_size"></a> [node\_storage\_size](#input\_node\_storage\_size) | Size of the node data disk in GB (default: 100) | `number` | `100` | no |
| <a name="input_node_storage_type"></a> [node\_storage\_type](#input\_node\_storage\_type) | Type of node storage SATA, SAS or SSD (default: SATA) | `string` | `"SATA"` | no |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | Enable the scaling for the node pool. Please note that CCE cluster must have autoscaling addon installed. (default: 10) | <pre>list(object({<br/>    effect = string<br/>    key    = string<br/>    value  = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "effect": "PreferNoSchedule",<br/>    "key": "gpu-node",<br/>    "value": "true"<br/>  }<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to add to resources that support them. | `map(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->