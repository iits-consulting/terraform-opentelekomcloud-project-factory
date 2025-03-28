# :warning: NOTIFICATION: SPLIT REPOSITORY

Effective March 25, 2025, **this repository will be deprecated** and no longer maintained. To ensure you continue receiving the latest updates and support, **please transition to using our dedicated Terraform module repositories**, each maintained separately.

- [acme](https://github.com/iits-consulting/terraform-opentelekomcloud-acme)
- [cce](https://github.com/iits-consulting/terraform-opentelekomcloud-cce)
- [cce-gpu-node-pool](https://github.com/iits-consulting/terraform-opentelekomcloud-cce-gpu-node-pool)
- [cert-manager](https://github.com/iits-consulting/terraform-opentelekomcloud-cert-manager)
- [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-crd-installer)
- [cts](https://github.com/iits-consulting/terraform-opentelekomcloud-cts)
- [dedicated-loadbalancer](https://github.com/iits-consulting/terraform-opentelekomcloud-dedicated-loadbalancer)
- [enterprise-vpn-connection](https://github.com/iits-consulting/terraform-opentelekomcloud-enterprise-vpn-connection)
- [enterprise-vpn-gateway](https://github.com/iits-consulting/terraform-opentelekomcloud-enterprise-vpn-gateway)
- [evs](https://github.com/iits-consulting/terraform-opentelekomcloud-evs)
- [jumphost](https://github.com/iits-consulting/terraform-opentelekomcloud-jumphost)
- [keycloak-sso-oidc](https://github.com/iits-consulting/terraform-opentelekomcloud-keycloak-sso-oidc)
- [keycloak-sso-saml](https://github.com/iits-consulting/terraform-opentelekomcloud-keycloak-sso-saml)
- [loadbalancer](https://github.com/iits-consulting/terraform-opentelekomcloud-loadbalancer)
- [obs-restricted](https://github.com/iits-consulting/terraform-opentelekomcloud-obs-restricted)
- [obs-secrets-reader](https://github.com/iits-consulting/terraform-opentelekomcloud-obs-secrets-reader)
- [obs-secrets-writer](https://github.com/iits-consulting/terraform-opentelekomcloud-obs-secrets-writer)
- [private-dns](https://github.com/iits-consulting/terraform-opentelekomcloud-private-dns)
- [projects](https://github.com/iits-consulting/terraform-opentelekomcloud-projects)
- [public-dns](https://github.com/iits-consulting/terraform-opentelekomcloud-public-dns)
- [rds](https://github.com/iits-consulting/terraform-opentelekomcloud-rds)
- [sfs](https://github.com/iits-consulting/terraform-opentelekomcloud-sfs)
- [snat](https://github.com/iits-consulting/terraform-opentelekomcloud-snat)
- [state-bucket](https://github.com/iits-consulting/terraform-opentelekomcloud-state-bucket)
- [vpc](https://github.com/iits-consulting/terraform-opentelekomcloud-vpc)
- [vpn](https://github.com/iits-consulting/terraform-opentelekomcloud-vpn)
- [waf](https://github.com/iits-consulting/terraform-opentelekomcloud-waf)

# Common Terraform Modules for Open Telekom Cloud

[![Apache-2.0 License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?)](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/blob/master/LICENSE)
![ViewCount](https://views.whatilearened.today/views/github/iits-consulting/terraform-opentelekomcloud-project-factory.svg)
[![Terratest](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/actions/workflows/terratest.yaml/badge.svg)](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/actions/workflows/terratest.yaml)

These are commonly usable Terraform Modules for the [Open Telekom Cloud](https://open-telekom-cloud.com) based on the
awesome [Terraform OTC Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs).

_These modules are developed by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a
Service!_

## Usage:

For fully integrated examples please visit the [Terratest Directory](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/Terratest)
You pick modules which you would like to use like this:

```hcl
module "vpc" {
   source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
   version    = "5.2.0"
   name       = "myproject-dev-vpc"
   cidr_block = "192.168.0.0/16"
   subnets = {
      "myproject-dev-subnet" = cidrsubnet("192.168.0.0/16", 1, 0)
   }
}
```

## Currently Available Modules

- [ACME:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/acme) Create, sign and update HTTPS certificates via OTC DNS
- [CCE:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/cce) A module designed to support full capabilities of OTC CCE while simplifying the configuration for ease of use.
- [cts:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/cts) This module enables the Cloud Tracing functionality in the OTC.
- [jumphost:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/jumphost) A module designed to create SSH jumphosts via OTC ECS for private networks.
- [keycloak_saml:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/keycloak_sso_saml) Connects Keycloak with OTC SAML IDP
- [keycloak_oidc:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/keycloak_sso_oidc) Connects Keycloak with OTC OIDC IDP
- [loadbalancer:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/loadbalancer) Module for creating an OTC ELB resource with public EIP
- [obs_secrets_reader:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/obs_secrets_reader) This modules reads JSON formatted secrets from an OBS bucket.
- [obs_secrets_writer:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/obs_secrets_writer) This modules creates an OBS Bucket with KMS SSE default encryption and a JSON encoded secrets file within the bucket.
- [obs_restricted:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/obs_restricted) This modules creates OBS bucket restricted by predefined access policy.
- [private_dns:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/private_dns) Create and manage a private DNS zone within you VPC
- [public_dns:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/public_dns) Create and manage a public DNS zone
- [rds:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/rds) A module designed to support full capabilities of OTC RDS while simplifying the configuration for ease of use.
- [snat:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/snat) Public SNAT gateway to grant internet access from a VPC without shared SNAT.
- [vpn:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/vpn) Creates a VPN tunnel.
- [waf:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/waf) Create Web Application Firewall for a Domain
- [evs:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/evs) Create an encrypted Elastic Volume Service (EVS)
- [state_bucket:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/state_bucket) Create an encrypted state bucket for Terraform
- [cce_gpu_node_pool:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/cce_gpu_node_pool) GPU Node Pool for CCE

## Quickstart

As a quick start we recommend using this template:

- https://github.com/iits-consulting/otc-terraform-template

Then just adjust the set-env.sh and the showcase/dev/main.tf as you wish

## Common Concepts behind the modules

There are some variables that occur on multiple modules. The ideas behind them are explained here.

| Variable   | Description                          | Example                       |
| :--------- | :----------------------------------- | :---------------------------- |
| `context`  | A human-readable name of the project | `website`, `payments-service` |
| `stage   ` | Name of the environment              | `dev`, `test`, `qa`, `prod`   |

## Remarks

The following modules are currently not working for Swiss OTC:

- [public_dns:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/public_dns) Create and manage a public DNS zone
- [waf:](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/waf) Create Web Application Firewall for a Domain

## Recommendations

1. We recommend this kind of Terraform folder structure:

   ![terraform-architecture](https://raw.githubusercontent.com/iits-consulting/terraform-opentelekomcloud-project-factory/master/docs/terraform-architecture.png?token=ANLMHOIDTUQL6GGQVNHTC7DAZNHMI)

2. [Set up a secure remote Terraform state](./tf_state_backend)
   . Copy the backend output of that module to your `settings.tf` file
3. Use https://github.com/iits-consulting/otc-infrastructure-charts-template if you want to use ArgoCD (GitOps)
<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

<!-- END_TF_DOCS -->

<<<<<<< HEAD

=======

> > > > > > > 9d63e9e (docs: deprecation warning)
