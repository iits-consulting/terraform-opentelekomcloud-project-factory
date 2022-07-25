## OTC Cloud Search Service Terraform module

A module designed to support full capabilities of OTC CSS while simplifying the configuration for ease of use.

### Usage example

```hcl
module "elasticsearch" {
  source  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/elasticsearch"
  version = "4.2.0"
  tags    = var.tags
  name    = "mycontext-stage-es"

  vpc_id                 = module.vpc.vpc.id
  subnet_id              = values(module.vpc.subnets)[0].id
  sg_secgroup_id         = module.cce.node_sg_id
  es_version             = "7.6.2"
  es_flavor              = "css.medium.8"
  es_storage_size        = 40
  es_storage_type        = "HIGH"
}
```

### Notes:

- This module requires existing security group (in example above, the node sec group of cce cluster)