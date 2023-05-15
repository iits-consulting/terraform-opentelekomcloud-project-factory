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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_acme"></a> [acme](#provider\_acme) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [acme_certificate.certificate](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate) | resource |
| [acme_registration.registration](https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/registration) | resource |
| [opentelekomcloud_identity_group_membership_v3.dns_admin_membership](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_membership_v3) | resource |
| [opentelekomcloud_identity_group_v3.dns_admin_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_v3) | resource |
| [opentelekomcloud_identity_role_assignment_v3.dns_admin_to_dns_admin_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_role_assignment_v3) | resource |
| [opentelekomcloud_identity_user_v3.dns_admin](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_v3) | resource |
| [random_password.dns_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_rotating.password_rotation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [time_sleep.cert_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.registration](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [opentelekomcloud_identity_project_v3.project](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_identity_role_v3.dns_admin_role](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_role_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_key_type"></a> [cert\_key\_type](#input\_cert\_key\_type) | The key type for the certificate's private key. Can be one of: P256 and P384 (for ECDSA keys of respective length) or 2048, 4096, and 8192 (for RSA keys of respective length). (default: P256) | `string` | `"P256"` | no |
| <a name="input_cert_min_days_remaining"></a> [cert\_min\_days\_remaining](#input\_cert\_min\_days\_remaining) | Number of days remaining when terraform apply will automatically renew the certificate. (default: 30) | `number` | `30` | no |
| <a name="input_cert_registration_email"></a> [cert\_registration\_email](#input\_cert\_registration\_email) | E-mail associated with certificate generation. | `string` | n/a | yes |
| <a name="input_cert_registration_key_type"></a> [cert\_registration\_key\_type](#input\_cert\_registration\_key\_type) | The key type for the ACME registration private key. Can be one of: P256 and P384 (for ECDSA keys of respective length) or 2048, 4096, and 8192 (for RSA keys of respective length). (default: P256) | `string` | `"P256"` | no |
| <a name="input_dns_admin_name"></a> [dns\_admin\_name](#input\_dns\_admin\_name) | Name of the automated DNS admin user. (default: terraform\_acme\_dns\_manager) | `string` | `"terraform_acme_dns_manager"` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | Map of common names to alternative names to create ACME certificates. Module supports wildcard certificates, common name does not need to be included in alternative names. | `map(list(string))` | n/a | yes |
| <a name="input_otc_domain_name"></a> [otc\_domain\_name](#input\_otc\_domain\_name) | OTC domain name for the cloud subscription. Usually in form OTC-EU-DE-000000000010XXXXXXXX | `string` | n/a | yes |
| <a name="input_otc_project_name"></a> [otc\_project\_name](#input\_otc\_project\_name) | OTC project name in format "eu-de\_<project\_name>" or "eu-nl\_<project\_name>". The project must have the dns zone(s) created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate"></a> [certificate](#output\_certificate) | n/a |
<!-- END_TF_DOCS -->
