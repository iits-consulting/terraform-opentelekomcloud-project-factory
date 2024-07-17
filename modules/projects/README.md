## Projects

A module designed to create and manage projects. The module is designed to automatically add agencies required for KMS-SSE and CCE to all projects it creates. It will also add the same agencies to existing region level projects (eu-de and eu-nl).

Usage example:
```
module "projects" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/projects"
  version    = "6.0.2"
  projects   = {
    eu-de_myproject-dev  = "Development stage for the myproject."
    eu-de_myproject-prod = "Production stage for the myproject."
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_opentelekomcloud"></a> [opentelekomcloud](#requirement\_opentelekomcloud) | >=1.34.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_opentelekomcloud"></a> [opentelekomcloud](#provider\_opentelekomcloud) | >=1.34.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opentelekomcloud_identity_agency_v3.cce_admin_trust](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_agency_v3) | resource |
| [opentelekomcloud_identity_agency_v3.evs_access_kms](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_agency_v3) | resource |
| [opentelekomcloud_identity_project_v3.projects](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs/resources/identity_project_v3) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_projects"></a> [projects](#input\_projects) | A map of project names to project descriptions. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->