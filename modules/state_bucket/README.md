## Encrypted Terraform remote state

The script essentially sets up an OpenTelekomCloud Object Storage Service (OBS) bucket for storing Terraform states. 
This bucket is encrypted using an OpenTelekomCloud Key Management Service (KMS) key.

Usage Example:

```hcl
module "tf_state_bucket" {
  source = "../../../modules/state_bucket"
  tf_state_bucket_name = "${var.context}-${var.stage}-kubernetes-tfstate"
  providers = {
    opentelekomcloud = opentelekomcloud.top_level_project
  }
}
```

Notes:
- This module needs to run at _eu-de_ or any other top level project
- The resource cannot be deleted because of this flag
```hcl
  lifecycle {
    prevent_destroy = true
  }
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.34.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.34.4 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.provider_project_constraint](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [opentelekomcloud_kms_key_v1.remote_state_bucket_kms_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [opentelekomcloud_obs_bucket.remote_state_bucket](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/obs_bucket) | resource |
| [random_id.kms_key_unique_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tf_state_bucket_name"></a> [tf\_state\_bucket\_name](#input\_tf\_state\_bucket\_name) | Bucket name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_terraform_state_backend_config"></a> [terraform\_state\_backend\_config](#output\_terraform\_state\_backend\_config) | n/a |
<!-- END_TF_DOCS -->