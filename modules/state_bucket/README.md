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
  region = var.region
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