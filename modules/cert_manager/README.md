## Cert Manager

A module designed to install cert-manager Helm chart with DNS challenge capabilities. 

Usage example:
```hcl
module "cert_manager" {
  source        = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/cert_manager"
  version       = "6.0.2"
  chart_version = local.chart_versions.cert-manager
  email         = "iits@iits-consulting.de"
  username      = "${var.stage}-dns-admin"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [opentelekomcloud_identity_credential_v3.user_aksk](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_credential_v3) | resource |
| [opentelekomcloud_identity_group_membership_v3.user_to_dns_admin_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_membership_v3) | resource |
| [opentelekomcloud_identity_group_v3.dns_admin_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_v3) | resource |
| [opentelekomcloud_identity_role_assignment_v3.dns_admin_role_to_dns_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_role_assignment_v3) | resource |
| [opentelekomcloud_identity_user_v3.user](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_v3) | resource |
| [opentelekomcloud_identity_project_v3.current](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_identity_role_v3.dns_admin_role](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_role_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_email"></a> [email](#input\_email) | E-Mail to use for the ACME Registration and DNS management. | `string` | n/a | yes |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Name of the IITS cert-manager chart. | `string` | `"cert-manager"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Chart repository of the IITS cert-manager chart. | `string` | `"https://charts.iits.tech"` | no |
| <a name="input_chart_set_parameter"></a> [chart\_set\_parameter](#input\_chart\_set\_parameter) | Override the values of the IITS cert-manager chart using set. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_chart_set_sensitive_parameter"></a> [chart\_set\_sensitive\_parameter](#input\_chart\_set\_sensitive\_parameter) | Override the values of the IITS cert-manager chart using set\_sensitive. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_chart_values"></a> [chart\_values](#input\_chart\_values) | Override the values of the IITS cert-manager chart using value files. | `list(string)` | `[]` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Chart version of the IITS cert-manager chart. | `string` | `"1.16.1"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Name the helm release. | `string` | `"cert-manager"` | no |
| <a name="input_release_namespace"></a> [release\_namespace](#input\_release\_namespace) | Namespace for the chart releases. | `string` | `"cert-manager"` | no |
| <a name="input_username"></a> [username](#input\_username) | Desired username for cert-manager DNS administrator user. | `string` | `"cert-manager-dns-admin"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->