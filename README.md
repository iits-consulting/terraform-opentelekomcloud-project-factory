# Common Terraform Modules for Open Telekom Cloud

[![Apache-2.0 License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?)](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/blob/master/LICENSE)
![ViewCount](https://views.whatilearened.today/views/github/iits-consulting/terraform-opentelekomcloud-project-factory.svg)

These are commonly usable Terraform Modules for the [Open Telekom Cloud](https://open-telekom-cloud.com) based on the
awesome [Terraform OTC Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs).

*These modules are developed by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a
Service!*

## Usage:

You pick modules which would like to use like this:

```hcl
module "vpc" {
   source     = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
   version    = "4.0.0"
   name       = "myproject-dev-vpc"
   cidr_block = "192.168.0.0/16"
   subnets = {
      "myproject-dev-subnet" = cidrsubnet("192.168.0.0/16", 1, 0)
   }
}
```

## Quickstart

As a quick start we recommend using this template: 

- https://github.com/iits-consulting/otc-terraform-template

Then just adjust the set-env.sh and the showcase/dev/main.tf as you wish

## Common Concepts behind the modules

There are some variables that occur on multiple modules. The ideas behind them are explained here.

| Variable   | Description                          | Example                       |
|:-----------|:-------------------------------------|:------------------------------|
| `context`  | A human-readable name of the project | `website`, `payments-service` |
| `stage   ` | Name of the environment              | `dev`, `test`, `qa`, `prod`   |


## Recommendations

1. We recommend this kind of Terraform folder structure:

   ![terraform-architecture](https://raw.githubusercontent.com/iits-consulting/terraform-opentelekomcloud-project-factory/master/docs/terraform-architecture.png?token=ANLMHOIDTUQL6GGQVNHTC7DAZNHMI)

2. [Set up a secure remote Terraform state](./tf_state_backend/README.md)
   . Copy the backend output of that module to your `settings.tf` file
3. Use https://github.com/iits-consulting/otc-infrastructure-charts-template if you want to use ArgoCD (GitOps)

## Currently Available Modules
- [ACME:](./modules/acme/README.md) Create, sign and update HTTPS certificates via OTC DNS
- [CCE:](./modules/cce/README.md) A module designed to support full capabilities of OTC CCE while simplifying the configuration for ease of use.
- [cloud_tracing_service:](./modules/cloud_tracing_service/README.md)This module enables the Cloud Tracing functionality in the OTC.
- [jumphost:](./modules/jumphost/README.md) A module designed to create SSH jumphosts via OTC ECS for private networks.
- [loadbalancer:](./modules/loadbalancer/README.md) Module for creating an OTC ELB resource with public EIP
- [obs_secrets_reader:](./modules/obs_secrets_reader/README.md) This modules reads JSON formatted secrets from an OBS bucket.
- [obs_secrets_writer:](./modules/obs_secrets_writer/README.md) This modules creates an OBS Bucket with KMS SSE default encryption and a JSON encoded secrets file within the bucket.
- [private_dns:](./modules/private_dns/README.md) Create and manage a private DNS zone within you VPC
- [rds:](./modules/rds/README.md) A module designed to support full capabilities of OTC RDS while simplifying the configuration for ease of use.
- [snat:](./modules/snat) Public SNAT gateway to grant internet access from a VPC without shared SNAT.
- [waf:](./modules/waf/README.md) Create Web Application Firewall for a Domain
