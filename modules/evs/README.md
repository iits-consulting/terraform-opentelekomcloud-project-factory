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
| [opentelekomcloud_evs_volume_v3.evs_volumes](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/evs_volume_v3) | resource |
| [opentelekomcloud_kms_key_v1.volume_kms_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [random_id.volume_kms_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_prefix"></a> [kms\_key\_prefix](#input\_kms\_key\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_volume_names"></a> [volume\_names](#input\_volume\_names) | n/a | `list(string)` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `list` | <pre>[<br>  "eu-de-01"<br>]</pre> | no |
| <a name="input_spec"></a> [spec](#input\_spec) | n/a | `map` | <pre>{<br>  "device_type": "SCSI",<br>  "size": 20,<br>  "volume_type": "SSD"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_volumes"></a> [volumes](#output\_volumes) | n/a |
<!-- END_TF_DOCS -->