# Terraform OpenTelekomCloud Module

This is a Terraform module that provisions encrypted Elastic Volume Service (EVS) on OpenTelekomCloud.
This module is capable of creating multiple EVS volumes using parameters for their names, specifications, and availability zones.


### Usage example

```hcl

module "elasticsearch_volumes" {
  source      = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/evs"
  volume_names       = ["elasticsearch-${var.stage}-0","elasticsearch-${var.stage}-1"]
  availability_zones = [  "eu-de-02", "eu-de-03"]
  kms_key_prefix     = "elasticsearch-${var.stage}"
  spec = {
    size        = 200
    volume_type = "SSD"
    device_type = "SCSI"
  }
  tags = local.tags
}


```


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| opentelekomcloud | * |

## Providers

| Name | Version |
|------|---------|
| opentelekomcloud | * |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| volume_names | List of names for the volumes to be created | list(string) | n/a | yes |
| tags | Common tag set for project resources | map(string) | {} | no |
| spec | Volume specifications like size, volume type and device type | object | { size=20, volume_type="SSD", device_type="SCSI" } | no |
| availability_zones | List of availability zones for the volumes | list(string) | ["eu-de-01"] | no |
| kms_key_prefix | Prefix to be used for creating the kms key | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| volumes | A map of created volumes where keys are volume names |
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
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `list` | <pre>[<br/>  "eu-de-01"<br/>]</pre> | no |
| <a name="input_spec"></a> [spec](#input\_spec) | n/a | `map` | <pre>{<br/>  "device_type": "SCSI",<br/>  "size": 20,<br/>  "volume_type": "SSD"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tag set for project resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_volumes"></a> [volumes](#output\_volumes) | n/a |
<!-- END_TF_DOCS -->