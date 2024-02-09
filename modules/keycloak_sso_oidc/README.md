## Configure Keycloak as a single sign on identity provider for OTC. (OIDC)

Usage Example:

```hcl
  module "otc_keycloak_sso_oidc" {
  source               = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/keycloak_sso_oidc"
  keycloak_realm       = "my_keycloak_realm"
  keycloak_domain_name = "https://auth.mydomain.de"
  otc_idp_name         = "my_project_keycloak_SSO-oidc"
  otc_idp_rules        = jsonencode([
    {
      remote = [
        {
          type = "given_name"
        },
        {
          type = "family_name"
        },
        {
          any_one_of = ["OTC-ADMIN", "SYSTEM-ADMINISTRATOR"],
          type       = "groups"
        }
      ],
      local = [
        {
          user = {
            name = "{0} {1}"
          }
        },
        {
          "group" : {
            "name" : "admin"
          }
        }
      ]
    }
  ])
}
```

Notes:
- Module requires a functional keycloak and will use the [keycloak provider](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs)
- Module requires admin privileges for keycloak provider in order to create and configure an OIDC client.
- The rule mapping syntax for OTC is documented [here](https://docs.otc.t-systems.com/en-us/usermanual/iam/en-us_topic_0079620340.html).
- Variable `otc_idp_rules` accepts any JSON string for fully customizable rules. For complex rule structures, it is possible to read it from a file:
```hcl
    module "otc_keycloak_sso_oidc" {
      source               = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/keycloak_sso_oidc"
      keycloak_realm       = "my_keycloak_realm"
      keycloak_domain_name = "https://auth.mydomain.de"
      otc_idp_name         = "my_project_keycloak_SSO"
      otc_idp_rules        = file("./path/to/rules.json")
    }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_curl"></a> [curl](#provider\_curl) | n/a |
| <a name="provider_errorcheck"></a> [errorcheck](#provider\_errorcheck) | n/a |
| <a name="provider_keycloak"></a> [keycloak](#provider\_keycloak) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [errorcheck_is_valid.cert_endpoint_check](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [keycloak_openid_client.otc](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client_default_scopes.otc_default_scopes](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_client_default_scopes) | resource |
| [opentelekomcloud_identity_provider.provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_provider) | resource |
| [curl_curl.oidc_keys](https://registry.terraform.io/providers/anschoewe/curl/latest/docs/data-sources/curl) | data source |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_keycloak_domain_name"></a> [keycloak\_domain\_name](#input\_keycloak\_domain\_name) | The domain name for the keycloak instance. | `string` | n/a | yes |
| <a name="input_keycloak_realm"></a> [keycloak\_realm](#input\_keycloak\_realm) | Keycloak realm to create SAML client. | `string` | n/a | yes |
| <a name="input_otc_idp_name"></a> [otc\_idp\_name](#input\_otc\_idp\_name) | Name of the identity provider resources in Open Telekom Cloud. | `string` | n/a | yes |
| <a name="input_otc_idp_rules"></a> [otc\_idp\_rules](#input\_otc\_idp\_rules) | n/a | `string` | n/a | yes |
| <a name="input_keycloak_client_name"></a> [keycloak\_client\_name](#input\_keycloak\_client\_name) | Keycloak Client name for the Open Telekom Cloud IDP client. (Default: otc-login | `string` | `"otc-login"` | no |
| <a name="input_otc_auth_endpoint"></a> [otc\_auth\_endpoint](#input\_otc\_auth\_endpoint) | Authentication endpoint for Open Telekom Cloud. Default: auth.otc.t-systems.com | `string` | `"auth.otc.t-systems.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otc_sso_url"></a> [otc\_sso\_url](#output\_otc\_sso\_url) | n/a |
<!-- END_TF_DOCS -->
