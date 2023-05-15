## OBS Secrets Reader for reading Terraform secrets

This modules reads JSON formatted secrets from an OBS bucket.

Use this module if you need to read your JSON formatted data and secrets from an OBS bucket.

### Usage example

```hcl
provider "opentelekomcloud" {
  auth_url    = "https://iam.${var.region}.otc.t-systems.com/v3"
  tenant_name = var.region
}

module "stage_secrets_from_encrypted_s3_bucket" {
  source             = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/obs_secrets_reader"
  version            = "1.3.4"
  bucket_name        = "${var.context_name}-${var.stage_name}-stage-secrets"
  bucket_object_name = "stage-secrets"
  required_secrets = [
    "kubectlConfig",
    "elbId",
    "elbPublicIp",
    "kubernetesEndpoint",
    "kubernetesClientCertificate",
    "kubernetesClientKey",
    "kubernetesCaCert",
  ]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.check_secrets](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [opentelekomcloud_s3_bucket_object.secrets](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/s3_bucket_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket name to read secrets from. Make sure the provider for this module has access to both the bucket and the KMS resource in case of encryption. | `string` | n/a | yes |
| <a name="input_bucket_object_key"></a> [bucket\_object\_key](#input\_bucket\_object\_key) | Path and name to the object within the bucket. | `string` | n/a | yes |
| <a name="input_required_secrets"></a> [required\_secrets](#input\_required\_secrets) | Optional list of top level secret names (keys) to exist within the file. Any missing keys will result in an error. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secrets"></a> [secrets](#output\_secrets) | n/a |
<!-- END_TF_DOCS -->
