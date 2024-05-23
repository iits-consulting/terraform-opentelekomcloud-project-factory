## Scalable File Service (SFS)

A module designed to create and manage SFS volumes with configurable encryption and backup systems.

Usage example:
```
module "sfs" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/sfs"
  version    = "6.0.2"

  availability_zone = "eu-de-01"
  vpc_id            = module.vpc.vpc.id
  subnet_id         = module.vpc.subnets["mysubnet"].id
  volume_name       = "myvolume"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_cbr_policy_v3.backup_policy](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/cbr_policy_v3) | resource |
| [opentelekomcloud_cbr_vault_v3.backup_vault](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/cbr_vault_v3) | resource |
| [opentelekomcloud_kms_key_v1.sfs_volume_kms_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [opentelekomcloud_networking_secgroup_v2.sfs_volume_sg](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/networking_secgroup_v2) | resource |
| [opentelekomcloud_sfs_turbo_share_v1.sfs_volume](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/sfs_turbo_share_v1) | resource |
| [random_id.sfs_volume_kms_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet network id where the SFS volume will be created in. | `string` | n/a | yes |
| <a name="input_volume_name"></a> [volume\_name](#input\_volume\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id where the SFS volume will be created in. | `any` | n/a | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | n/a | `string` | `"eu-de-01"` | no |
| <a name="input_kms_key_create"></a> [kms\_key\_create](#input\_kms\_key\_create) | n/a | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Existing KMS Key ID if one is already created. | `string` | `null` | no |
| <a name="input_share_type"></a> [share\_type](#input\_share\_type) | Filesystem type of the SFS volume. (Default: STANDARD) | `string` | `"STANDARD"` | no |
| <a name="input_size"></a> [size](#input\_size) | Size of the SFS volume in GB. (Default: 500) | `number` | `500` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_volume"></a> [volume](#output\_volume) | n/a |
<!-- END_TF_DOCS -->