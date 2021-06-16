# Common Terraform Modules for Open Telekom Cloud

These are commonly usable Terraform Modules for the [Open Telekom Cloud](https://open-telekom-cloud.com) based on the
awesome [Terraform OTC Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs).

*These modules are developed by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a
Service!*

# Usage:

You can utilize the modules individually (recommended for production scenarios) or import this whole repo as one
module (as a quickstart or showcase).

## Importing Modules Individually

```terraform
module "vpc" {
  source                = "iits/project-factory/opentelekomcloud//modules/vpc"
  version               = "0.1.0"
  vpc_cidr              = local.vpc_cidr
  vpc_name              = "vpc-otc-demo-dev"
  stage_name            = "dev"
  vpc_subnet_cidr       = local.vpc_cidr
  vpc_subnet_gateway_ip = local.vpc_subnet_gateway_ip
}
```

## Importing the whole Showcase Environment

1. (optional) Set up remote terrafom state with obs_tf_state module. Copy the backend output of that module to the
   settings.tf.
2. Create the showcase environment with a VPC, loadbalancer and CCE.

```terraform
module "iits-otc-demo" {
  source  = "iits/project-factory/opentelekomcloud"
  version = "0.1.0"
  ...
}
```

# Common Concepts behind the modules

There are some variables that occur on multiple modules. The ideas behind them are explained here.

## Context

The "context_name" variable should be a human-readable name of the project you are working on or the team you are
provisioning infrastructure for.

## Stage

The "stage" variable is utilized to distinguish between multiple mostly equal, but separate environments like "dev", "
test", "qa", "prod".
