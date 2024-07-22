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
| [helm_release.otc-prometheus-exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [opentelekomcloud_identity_credential_v3.user_aksk](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_credential_v3) | resource |
| [opentelekomcloud_identity_group_v3.group](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_group_v3) | resource |
| [opentelekomcloud_identity_role_assignment_v3.role_assignment_read](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_role_assignment_v3) | resource |
| [opentelekomcloud_identity_user_group_membership_v3.membership](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_group_membership_v3) | resource |
| [opentelekomcloud_identity_user_v3.user](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_user_v3) | resource |
| [opentelekomcloud_identity_project_v3.project](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_project_v3) | data source |
| [opentelekomcloud_identity_role_v3.ces_role](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/data-sources/identity_role_v3) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of the OTC | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix of the OTC ressources created. | `string` | n/a | yes |
| <a name="input_release_version"></a> [release\_version](#input\_release\_version) | Release version of the chart (see releases on https://github.com/iits-consulting/otc-prometheus-exporter/tree/gh-pages) | `string` | n/a | yes |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Name ot the release namespace. | `string` | `"otc-prometheus-exporter"` | no |
| <a name="input_release_namespace"></a> [release\_namespace](#input\_release\_namespace) | Kubernetes namespace to install the chart to. | `string` | `"monitoring"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->