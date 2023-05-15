## Jumphost Module

A module designed to create SSH jumphosts via OTC ECS for private networks. 

Usage example:
```hcl
module "vpc" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  cidr_block = local.vpc_cidr
  name       = "vpc-demo"
  subnets    = {
    "subnet-demo" = "default_cidr"
  }
}

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

module "jumphost" {
  source        = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/jumphost"
  vpc_id        = module.vpc.vpc.id
  subnet_id     = values(module.vpc.subnets)[0].id
  node_name     = "jumphost-demo"
  node_image_id = data.opentelekomcloud_images_image_v2.ubuntu.id
  cloud_init    = join("\n", concat(["#cloud-config"], [for path in fileset("", "${"./example_cloud_init"}/*.{yml,yaml}") : file(path)]))
}
```

> **WARNING:** The parameter `node_storage_encryption_enabled` should be kept as `false` unless an agency for EVS is created with:
> - Agency Name = `EVSAccessKMS`
> - Agency Type = `Account`
> - Delegated Account = `op_svc_evs`
> - Permissions = `KMS Administrator` within the project

Notes:
- Please see [example_cloud_init](../../example_cloud_init) for example cloud_init configuration
- More examples of cloud-init can be found in [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
- For complete documentation of cloud init, please see [cloud-init Documentation](https://cloudinit.readthedocs.io/en/latest/index.html)
- The jumphost module is designed to ignore changes in the node_image_id parameter. 
- The jumphost node's boot drive is also designed to be preserved even if the instance is destroyed for data resiliency.
- If an image update or clean boot drive is intended,
  please use taint or destroy:
```bash
terraform destroy -target module.<module_name>.opentelekomcloud_blockstorage_volume_v2.jumphost_boot_volume
```
or
```bash
terraform taint module.<module_name>.opentelekomcloud_blockstorage_volume_v2.jumphost_boot_volume
terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.31.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.31.5 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.availability_zone](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [opentelekomcloud_blockstorage_volume_v2.jumphost_boot_volume](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/blockstorage_volume_v2) | resource |
| [opentelekomcloud_compute_instance_v2.jumphost_node](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/compute_instance_v2) | resource |
| [opentelekomcloud_kms_key_v1.jumphost_storage_encryption_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [opentelekomcloud_networking_floatingip_associate_v2.jumphost_eip_association](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_floatingip_associate_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.jumphost_secgroup_rule_internet](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.jumphost_secgroup_rule_ssh](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.jumphost_sg_group_in](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_rule_v2.jumphost_sg_group_out](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [opentelekomcloud_networking_secgroup_v2.jumphost_secgroup](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_v2) | resource |
| [opentelekomcloud_vpc_eip_v1.jumphost_eip](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/vpc_eip_v1) | resource |
| [random_id.jumphost_storage_encryption_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.host_key_ecdsa](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.host_key_ed25519](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.host_key_rsa](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_kms_key_v1.jumphost_storage_existing_encryption_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/kms_key_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | Additional security group names for Jumphost. | `list(string)` | `[]` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone for the jumphost node. | `string` | `""` | no |
| <a name="input_cloud_init"></a> [cloud\_init](#input\_cloud\_init) | Custom Cloud-init configuration. Cloud-init cloud config format is expected. Only *.yml and *.yaml files will be read. | `string` | `""` | no |
| <a name="input_node_bandwidth_size"></a> [node\_bandwidth\_size](#input\_node\_bandwidth\_size) | Jumphost node external IP bandwidth size in Mbps. (default: 10) | `number` | `10` | no |
| <a name="input_node_flavor"></a> [node\_flavor](#input\_node\_flavor) | Jumphost node specifications in otc flavor format. (default: s3.medium.2 (3rd generation 1 Core 2GB RAM)) | `string` | `"s3.medium.2"` | no |
| <a name="input_node_image_id"></a> [node\_image\_id](#input\_node\_image\_id) | Jumphost node image name. Image must exist within the same project as the jumphost node. (default: 9f92079d-9d1b-4832-90c1-a3b4a1c00b9b (Standard\_Ubuntu\_20.04\_latest)) | `string` | `"9f92079d-9d1b-4832-90c1-a3b4a1c00b9b"` | no |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | Jumphost node name. | `any` | n/a | yes |
| <a name="input_node_storage_encryption_enabled"></a> [node\_storage\_encryption\_enabled](#input\_node\_storage\_encryption\_enabled) | Jumphost node system disk storage KMS encryption toggle. | `bool` | `false` | no |
| <a name="input_node_storage_encryption_key_name"></a> [node\_storage\_encryption\_key\_name](#input\_node\_storage\_encryption\_key\_name) | If jumphost system disk KMS encryption is enabled, use this KMS key name instead of creating a new one. | `string` | `null` | no |
| <a name="input_node_storage_size"></a> [node\_storage\_size](#input\_node\_storage\_size) | Jumphost node system disk storage size in GB. (default: 20) | `number` | `20` | no |
| <a name="input_node_storage_type"></a> [node\_storage\_type](#input\_node\_storage\_type) | Jumphost node system disk storage type. Must be one of "SATA", "SAS", or "SSD". (default: SSD) | `string` | `"SSD"` | no |
| <a name="input_preserve_host_keys"></a> [preserve\_host\_keys](#input\_preserve\_host\_keys) | Enable to generate host keys via terraform and preserve them in the state to keep node identity consistent. (default: true) | `bool` | `true` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Jumphost subnet id for node network configuration | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Jumphost tag set. | `map(string)` | `{}` | no |
| <a name="input_trusted_ssh_origins"></a> [trusted\_ssh\_origins](#input\_trusted\_ssh\_origins) | IP addresses and/or ranges allowed to SSH into the jumphost. (default: ["0.0.0.0/0"] (Allow access from all IP addresses.)) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jumphost_address"></a> [jumphost\_address](#output\_jumphost\_address) | n/a |
| <a name="output_jumphost_private_address"></a> [jumphost\_private\_address](#output\_jumphost\_private\_address) | n/a |
| <a name="output_jumphost_sg_id"></a> [jumphost\_sg\_id](#output\_jumphost\_sg\_id) | n/a |
<!-- END_TF_DOCS -->
