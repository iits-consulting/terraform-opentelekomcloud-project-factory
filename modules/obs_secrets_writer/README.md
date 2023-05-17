## OBS Secrets Writer for storing Terraform secrets

This modules creates an OBS Bucket with KMS SSE default encryption and a JSON encoded secrets file within the bucket.

Please remember that OBS and KMS work only on top level projects (eu-de or eu-nl) !!!

Please note that while this module supports complex objects and structures, all values of the secrets map must be of same type (map of strings, map of lists, map of maps etc.).

Use this module if you need to store your dynamic secrets somewhere secure and can not use more secure mechanism like HashiCorp Vault.

### Usage example

```hcl
provider "opentelekomcloud" {
  auth_url    = "https://iam.${var.region}.otc.t-systems.com/v3"
  tenant_name = var.region
  alias       = "top_level_project"
}

module "stage_secrets_to_encrypted_s3_bucket" {
  providers = {opentelekomcloud=opentelekomcloud.top_level_project}
  source            = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/obs_secrets_writer"
  version           = "1.3.4"
  bucket_name       = "${var.context_name}-${var.stage_name}-stage-secrets"
  bucket_object_key = "stage-secrets"
  secrets = {
    kubectlConfig               = module.cce.kubectl_config
    elbId                       = module.loadbalancer.elb_id
    elbPublicIp                 = module.loadbalancer.elb_public_ip
    kubernetesEndpoint          = module.cce.kube_api_endpoint
    kubernetesClientCertificate = base64decode(module.cce.client-certificate)
    kubernetesClientKey         = base64decode(module.cce.client-key)
    kubernetesCaCert            = base64decode(module.cce.client-key)
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.31.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.31.5 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_kms_key_v1.encrypted_secrets_key](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/kms_key_v1) | resource |
| [opentelekomcloud_obs_bucket.secrets](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/obs_bucket) | resource |
| [opentelekomcloud_obs_bucket_object.secrets](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/obs_bucket_object) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket name to read secrets from. Make sure the provider for this module has tennant\_name=<region> set | `string` | n/a | yes |
| <a name="input_bucket_object_key"></a> [bucket\_object\_key](#input\_bucket\_object\_key) | n/a | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | n/a | `map(any)` | n/a | yes |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Create a new bucket or use an existing one. Default: true | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Disable the versioning for the bucket. Default: true | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
