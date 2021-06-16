# Encrypted Remote State Bucket

## Usage

```hcl
module "obs-tf-state" {
  source      = "iits/project-factory/opentelekomcloud"
  version     = "0.1.0"
  # insert the 2 required variables here
  bucket_name = "some_bucket_name"
  region      = "eu-de"
}
```
