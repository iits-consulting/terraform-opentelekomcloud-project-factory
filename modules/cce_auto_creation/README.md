## CCE Auto Creation in Terraform

This module prepares the management of a CCE cluster in the OTC. Normally, a manual acceptance is needed in the OTC
console to enable the CCE features. This module emulates the acceptance click by creating an agency. 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.31.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.31.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_identity_agency_v3.enable_cce_auto_creation](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_agency_v3) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
