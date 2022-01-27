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

Set environment variables for the quickstart

```shell
# Either your ACCESS_KEY and SECRET_KEY or from a serviceaccount
export OS_ACCESS_KEY="REPLACE_ME"
export OS_SECRET_KEY="REPLACE_ME"
export AWS_ACCESS_KEY_ID=$OS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$OS_SECRET_KEY

export OS_DOMAIN_NAME="OTC-EU-DE-REPLACE_ME"
export OS_PROJECT_NAME="eu-de"
export TF_VAR_project_name=${OS_PROJECT_NAME}

export TF_VAR_region="eu-de"

# Current Stage you are working on for example dev,qa, prod etc.
export TF_VAR_stage_name="dev"
#Current Context you are working on can be customer name or cloud name etc.
export TF_VAR_context_name="showcase"
```


Add a `project-factory` module

```shell
module "iits-otc-demo" {
  source  = "iits-consulting/project-factory/opentelekomcloud"
  version = "1.2.2"
  ...
}
```

Apply the module

```shell
terraform init
terraform apply
```

## Importing Modules Individually

```terraform
module "vpc" {
  source                = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version               = "1.2.2"
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


## Recommendations

1. We recommend this kind of Terraform folder structure:

   ![terraform-architecture](https://raw.githubusercontent.com/iits-consulting/terraform-opentelekomcloud-project-factory/master/docs/terraform-architecture.png?token=ANLMHOIDTUQL6GGQVNHTC7DAZNHMI)

2. [Set up a secure remote Terraform state](./tf_state_backend/README.md)
   . Copy the backend output of that module to your `settings.tf` file