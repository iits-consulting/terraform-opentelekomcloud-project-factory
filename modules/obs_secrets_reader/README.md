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
  source             = "iits-consulting/project-factory/opentelekomcloud//modules/obs_secrets_reader"
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
