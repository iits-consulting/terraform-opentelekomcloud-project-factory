# Cloud Tracing Service (CTS)

This module enables the Cloud Tracing functionality in the OTC. It creates a encrypted OBS bucket and
connects it to a CTS tracker.

For general info see the OTC website at https://open-telekom-cloud.com/en/products-services/core-services/cloud-trace

## Usage

```
provider "opentelekomcloud" {
  auth_url       = "https://iam.${var.region}.otc.t-systems.com/v3"
}

provider "opentelekomcloud" {
  auth_url       = "https://iam.${var.region}.otc.t-systems.com/v3"
  tenant_name    = var.region
  alias          = "top_level_project"
}

module "cts" {
  source                = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/cts"
  version               = "6.0.0"
  bucket_name           = "my-bucket-for-cloud-tracing-service"
  enable_trace_analysis = true
  expiration_days       = 180
  providers = {
    opentelekomcloud.project           = opentelekomcloud
    opentelekomcloud.top_level_project = opentelekomcloud.top_level_project
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud.project"></a> [opentelekomcloud.project](#provider\_opentelekomcloud.project) | >=1.32.0 |
| <a name="provider_opentelekomcloud.top_level_project"></a> [opentelekomcloud.top\_level\_project](#provider\_opentelekomcloud.top\_level\_project) | >=1.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_cts_tracker_v3.cloud_tracing_service_tracker](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/cts_tracker_v3) | resource |
| [opentelekomcloud_kms_key_v1.cloud_tracing_service_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [opentelekomcloud_obs_bucket.cloud_tracing_service](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/obs_bucket) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | OBS Bucket name to store the traces (will be created automatically). | `string` | n/a | yes |
| <a name="input_cts_expiration_days"></a> [cts\_expiration\_days](#input\_cts\_expiration\_days) | How long should the data be preserved within the OBS bucket (in days). Default: 180 | `number` | `180` | no |
| <a name="input_enable_trace_analysis"></a> [enable\_trace\_analysis](#input\_enable\_trace\_analysis) | Enables/disable trace analysis (LTS) for the tracker. Default: true | `bool` | `true` | no |
| <a name="input_file_prefix"></a> [file\_prefix](#input\_file\_prefix) | Object name prefix to store the traces in the OBS. Default: cts | `string` | `"cts"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags to add to resources that support them. | `map(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

