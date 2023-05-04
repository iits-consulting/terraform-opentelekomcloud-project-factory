## Restricted OBS Bucket

This modules creates OBS bucket restricted by predefined access policy.

### Usage example

```hcl
provider "opentelekomcloud" {
  auth_url    = "https://iam.${var.region}.otc.t-systems.com/v3"
  tenant_name = var.region
}

module "obs_restricted" {
  source             = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/obs_restricted"
  version            = "5.3.0"
  bucket_name        = "my-bucket"
}
```
