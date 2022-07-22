## Create, sign and update HTTPS certificates via OTC DNS

Usage Example:

```hcl
module "acme_certificate" {
  source                  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/acme"
  cert_registration_email = "cert-test@iits-consulting.de"
  otc_domain_name         = var.otc_domain_name
  otc_project_name        = var.project_name
  domains = {
    "domain.com" = ["*.domain.com"]
  }
}
```

Notes:
- This module requires IAM permissions on OTC provider to create its own DNS Admin user.
- The DNS admin user is designed to rotate its password every 30 days to comply with password policies.
- This module is designed to work with OTC DNS and will require a valid public DNS zone configured.
- Due to a bug in letsencrypt go library, it is possible to get an error 400 from OTC when attempting DNS challenge. If it happens, simply retry applying.