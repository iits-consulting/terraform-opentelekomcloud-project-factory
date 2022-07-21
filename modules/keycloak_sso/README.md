## Configure Keycloak as a single sign on identity provider for OTC.

Usage Example:

```hcl
  module "otc_keycloak_sso" {
    source               = "iits-consulting/project-factory/opentelekomcloud//moduless/keycloak_sso"
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
- Module will require admin privilages for keycloak provider in order to create and configure a SAML client.
- The rule mapping syntax for OTC is documented [here](https://docs.otc.t-systems.com/en-us/usermanual/iam/en-us_topic_0079620340.html).
- Variable `otc_idp_rules` accepts any JSON string for fully customizable rules. For complex rule structures, it is possible to read it from a file:
```hcl
  module "otc_keycloak_sso" {
    source               = "iits-consulting/project-factory/opentelekomcloud//moduless/keycloak_sso"
    keycloak_realm       = "my_keycloak_realm"
    keycloak_domain_name = "https://auth.mydomain.de"
    otc_idp_name         = "my_project_keycloak_SSO"
    otc_idp_rules        = file("./path/to/rules.json")
```