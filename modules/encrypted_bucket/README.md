## Encrypted Bucket for storing terraform secrets

This modules creates a OBS Bucket and one file with default encryption.

Use this module if you need to store your dynamic secrets somewhere secure and can not use more secure mechanism like
HashiCorp Vault.

### Usage example

```hcl
module "stage_secrets_to_encrypted_s3_bucket" {
  source        = "iits-consulting/project-factory/opentelekomcloud//modules/encrypted_bucket"
  version       = "1.2.0"
  bucket_name   = "${var.context_name}-${var.stage_name}-stage-secrets"
  bucket_object_name = "stage-secrets"
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

###Consuming the bucket secrets
```hcl
data "opentelekomcloud_obs_bucket_object" "stage_secrets" {
  bucket = "${var.context_name}-${var.stage_name}-stage-secrets"
  key    = "stage-secrets"
}

locals {
  stage_secrets = jsondecode(data.opentelekomcloud_obs_bucket_object.stage_secrets.body)
}

provider "kubernetes" {
  host               = local.stage_secrets["kubernetesEndpoint"]
  client_certificate = local.stage_secrets["kubernetesClientCertificate"]
  client_key         = local.stage_secrets["kubernetesClientKey"]
}
```

