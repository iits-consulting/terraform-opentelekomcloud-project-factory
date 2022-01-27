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
  source            = "iits-consulting/project-factory/opentelekomcloud//modules/obs_secrets_writer"
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
