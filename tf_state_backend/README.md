# Encrypted Remote State Bucket

Creates an encrypted OBS Bucket for your terraform remote state.

After the creation it prints out the right backend s3 terraform settings which you can copy
and paste into your settings.tf

## Usage

Set your AK/SK and source such a bash file

```bash
export OS_ACCESS_KEY="<replace-me>"      # OTC Access Key ID (e.g. WTN5W8OLNKNJKVFVCY01)
export OS_SECRET_KEY="<replace-me>"      # OTC Secret Access Key (e.g. aFrR9bt7hXGIVbDcO73cnAlpUla06xZ4nytPOQZF)
export OS_DOMAIN_NAME="<replace-me"      # OTC domain for the project (e.g. OTC-EU-DE-00000000001000012345)
export TF_VAR_bucket_name="<replace-me"  # Bucket name to store terraform state (e.g iits-project-factory-tfstate-bucket)
export AWS_ACCESS_KEY_ID=$OS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$OS_SECRET_KEY
```

Create a new directory in your project copy the code from [main.tf](./main.tf) into it.

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

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
