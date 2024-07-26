<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >1.31.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >1.31.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.otc-prometheus-exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [opentelekomcloud_identity_credential_v3.user_aksk](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_credential_v3) | resource |
| [opentelekomcloud_identity_group_v3.ces_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_v3) | resource |
| [opentelekomcloud_identity_role_assignment_v3.ces_role_to_ces_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_role_assignment_v3) | resource |
| [opentelekomcloud_identity_user_group_membership_v3.user_to_ces_group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_group_membership_v3) | resource |
| [opentelekomcloud_identity_user_v3.user](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_v3) | resource |
| [opentelekomcloud_identity_project_v3.project](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_identity_role_v3.ces_role](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_role_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of the OTC | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix of the OTC ressources created. | `string` | n/a | yes |
| <a name="input_release_version"></a> [release\_version](#input\_release\_version) | Release version of the chart (see releases on https://github.com/iits-consulting/otc-prometheus-exporter/tree/gh-pages) | `string` | n/a | yes |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Name of the IITS otc-prometheus-exporter chart. | `string` | `"otc-prometheus-exporter"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Chart repository of the IITS otc-prometheus-exporter chart. | `string` | `"https://iits-consulting.github.io/otc-prometheus-exporter/"` | no |
| <a name="input_chart_set_parameter"></a> [chart\_set\_parameter](#input\_chart\_set\_parameter) | Override the values of the IITS otc-prometheus-exporter chart using set. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_chart_set_sensitive_parameter"></a> [chart\_set\_sensitive\_parameter](#input\_chart\_set\_sensitive\_parameter) | Override the values of the IITS otc-prometheus-exporter chart using set\_sensitive. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Name ot the release namespace. | `string` | `"otc-prometheus-exporter"` | no |
| <a name="input_release_namespace"></a> [release\_namespace](#input\_release\_namespace) | Kubernetes namespace to install the chart to. | `string` | `"monitoring"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->