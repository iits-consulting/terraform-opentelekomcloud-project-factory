## Configure Keycloak as a single sign on identity provider for OTC. (SAML)

Usage Example:

```hcl
  module "otc_keycloak_sso_saml" {
    source               = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/keycloak_sso_saml"
    keycloak_realm       = "my_keycloak_realm"
    keycloak_domain_name = "https://auth.mydomain.de"
    otc_idp_name         = "my_project_keycloak_SSO"
    otc_idp_rules = jsonencode([{
      remote = [
        {
          type = "givenName"
        },
        {
          type = "surname"
        },
        {
          any_one_of = ["ADMIN"],
          type       = "memberOf"
        }],
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
    }])
  }
```

Notes:
- Module requires a functional keycloak and will use the [keycloak provider](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs)
- Module requires admin privileges for keycloak provider in order to create and configure a SAML client.
- The rule mapping syntax for OTC is documented [here](https://docs.otc.t-systems.com/en-us/usermanual/iam/en-us_topic_0079620340.html).
- Variable `otc_idp_rules` accepts any JSON string for fully customizable rules. For complex rule structures, it is possible to read it from a file:
```hcl
    module "otc_keycloak_sso_saml" {
      source               = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/keycloak_sso_saml"
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
| [errorcheck_is_valid.saml_descriptor_check](https://registry.terraform.io/providers/iits-consulting/errorcheck/latest/docs/resources/is_valid) | resource |
| [keycloak_saml_client.otc](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/saml_client) | resource |
| [keycloak_saml_client_default_scopes.otc_default_scopes](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/saml_client_default_scopes) | resource |
| [opentelekomcloud_identity_mapping_v3.mapping](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_mapping_v3) | resource |
| [opentelekomcloud_identity_protocol_v3.saml](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_protocol_v3) | resource |
| [opentelekomcloud_identity_provider_v3.provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_provider_v3) | resource |
| [curl_curl.saml_descriptor](https://registry.terraform.io/providers/anschoewe/curl/latest/docs/data-sources/curl) | data source |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_keycloak_domain_name"></a> [keycloak\_domain\_name](#input\_keycloak\_domain\_name) | The domain name for the. | `string` | n/a | yes |
| <a name="input_keycloak_realm"></a> [keycloak\_realm](#input\_keycloak\_realm) | Keycloak realm to create SAML client. | `string` | n/a | yes |
| <a name="input_otc_idp_name"></a> [otc\_idp\_name](#input\_otc\_idp\_name) | Name of the identity provider resources in OTC. | `string` | n/a | yes |
| <a name="input_otc_idp_rules"></a> [otc\_idp\_rules](#input\_otc\_idp\_rules) | n/a | `string` | n/a | yes |
| <a name="input_otc_auth_endpoint"></a> [otc\_auth\_endpoint](#input\_otc\_auth\_endpoint) | Authentication endpoint for OTC. Default: https://auth.otc.t-systems.com | `string` | `"https://auth.otc.t-systems.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otc_sso_url"></a> [otc\_sso\_url](#output\_otc\_sso\_url) | n/a |
<!-- END_TF_DOCS -->
