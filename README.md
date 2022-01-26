# Common Terraform Modules for Open Telekom Cloud

[![Apache-2.0 License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?)](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/blob/master/LICENSE)
![ViewCount](https://views.whatilearened.today/views/github/iits-consulting/terraform-opentelekomcloud-project-factory.svg)

These are commonly usable Terraform Modules for the [Open Telekom Cloud](https://open-telekom-cloud.com) based on the
awesome [Terraform OTC Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs).

*These modules are developed by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a
Service!*

## Usage:

You can import this whole repo as one module (quickstart) or utilize the modules individually (recommended for
production).

## Quickstart

1. We recommend this kind of Terraform folder structure:

   ![terraform-architecture](https://raw.githubusercontent.com/iits-consulting/terraform-opentelekomcloud-project-factory/master/docs/terraform-architecture.png?token=ANLMHOIDTUQL6GGQVNHTC7DAZNHMI)

2. (
   optional) [Set up a secure remote Terraform state](./tf_state_backend/README.md)
   . Copy the backend output of that module to your `settings.tf` file
3. Add a `project-factory` module

```terraform
# System variables that have to be set for this example environment:
# - OS_ACCESS_KEY
# - OS_SECRET_KEY
# - OS_DOMAIN_NAME
# - OS_TENANT_NAME or OS_PROJECT_NAME

module "iits-otc-demo" {
  source  = "iits-consulting/project-factory/opentelekomcloud"
  version = "1.1.3"
  ...
}
```

## Importing Modules Individually

```terraform
module "vpc" {
  source                = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version               = "1.1.3"
  vpc_cidr              = local.vpc_cidr
  vpc_name              = "vpc-otc-demo-dev"
  stage_name            = "dev"
  vpc_subnet_cidr       = local.vpc_cidr
  vpc_subnet_gateway_ip = local.vpc_subnet_gateway_ip
}
```

## Common Concepts behind the modules

There are some variables that occur on multiple modules. The ideas behind them are explained here.

| Variable       | Description                          | Example                       |
|:---------------|:-------------------------------------|:------------------------------|
| `context_name` | A human-readable name of the project | `website`, `payments-service` |
| `stage   `     | Name of the environment              | `dev`, `test`, `qa`, `prod`   |
