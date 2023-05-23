## Restricted OBS Bucket

This modules creates an OBS Bucket with KMS SSE default encryption and user with access to it.

> **Note**  
> Please remember that OBS and KMS work only on top level projects (eu-de or eu-nl) !!!

### Usage example

```hcl
provider "opentelekomcloud" {
  alias       = "toplevel-de"
  max_retries = 100
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
  tenant_name = "eu-de"
  region      = "eu-de"
}

module "obs_restricted_eu_de" {
  source      = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/obs_restricted"
  bucket_name = var.bucket_name
  providers = {
    opentelekomcloud = opentelekomcloud.toplevel-de
  }
}
```
