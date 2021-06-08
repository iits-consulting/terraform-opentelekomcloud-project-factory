# terraform-otc-modules
These are commonly usable Terraform Modules for the Opentelekom Cloud: https://open-telekom-cloud.com
Developed by iits-consulting: https://iits-consulting.de/

# Usage:
You can utilize the modules individually (recommended for production scenarios) or import this whole repo as one module (as a quickstart or showcase).

## Importing modules individually
```terraform
module "vpc" {
  source                = "iits/otc//modules/vpc"
  version               = "0.1.0"
  vpc_cidr              = local.vpc_cidr
  vpc_name              = "vpc-otc-demo-dev"
  stage_name            = "dev"
  vpc_subnet_cidr       = local.vpc_cidr
  vpc_subnet_gateway_ip = local.vpc_subnet_gateway_ip
}
```

# Common Concepts behind the modules

There are some variables that occur on multiple modules. The ideas behind them are explained here.

## Context
The "context" variable should be a human-readable name of the project you are working on or the team you are provisioning infrastructure for.

## Stage
The "stage" variable is utilized to distinguish between multiple mostly equal, but separate environments like "dev", "test", "qa", "prod".
