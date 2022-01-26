# Encrypted Remote State Bucket

[![Apache-2.0 License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?)](https://github.com/iits-consulting/terraform-opentelekomcloud-obs-tf-state/blob/master/LICENSE)
![Terraform Lint](https://github.com/iits-consulting/terraform-opentelekomcloud-obs-tf-state/workflows/terraform-lint/badge.svg)
![ViewCount](https://views.whatilearened.today/views/github/iits-consulting/terraform-opentelekomcloud-obs-tf-state.svg)


Creates an encrypted OBS Bucket for your terraform remote state.

After the creation it prints out the right backend s3 terraform settings which you can copy
and paste into your settings.tf

## Usage

Set your AK/SK and source such a bash file

```bash
export ACCESS_KEY="REPLACE_ME" 
export SECRET_KEY="REPLACE_ME" 
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY 
export AWS_ACCESS_KEY_ID=$ACCESS_KEY 
export OS_ACCESS_KEY=$ACCESS_KEY 
export OS_SECRET_KEY=$SECRET_KEY
export TF_PLUGIN_CACHE_DIR="<path_to_project>/plugins" # Optional: allows plugin caching for terraform
```

Copy the directory [tf_state_backend](.) to your project. And configure the parameters in [config.auto.tfvars](./config.auto.tfvars) for your project.
```hcl
context  = "iits-project-factory"
customer = "IITS"
domain   = "<replace-me>"
# region   = "eu-de" // Optional: accepted values are eu-de(default) and eu-nl
```
## Example Output:
```hcl
backend "s3" {
  bucket = "iits-project-factory-tfstate-bucket"
  kms_key_id = "arn:aws:kms:eu-de:ddc3288175e341128f85ec419e2865a7:key/f8dfbd74-2c59-45bb-934f-d83dd4fb04f2"
  key = "tfstate"
  region = "eu-de"
  endpoint = "obs.eu-de.otc.t-systems.com"
  encrypt = true
  skip_region_validation = true
  skip_credentials_validation = true
}
```