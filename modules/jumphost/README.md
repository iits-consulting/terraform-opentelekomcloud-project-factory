## Jumphost Module

A module designed to create SSH jumphosts via OTC ECS for private networks. 

Usage example:
```hcl
module "vpc" {
  source     = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  cidr_block = local.vpc_cidr
  name       = "vpc-demo"
  subnets    = {
    "subnet-demo" = "default_cidr"
  }
}

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

module "jumphost" {
  source            = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/jumphost"
  vpc_id            = module.vpc.vpc.id
  subnet_id         = values(module.vpc.subnets)[0].id
  node_name         = "jumphost-demo"
  node_image_id     = data.opentelekomcloud_images_image_v2.ubuntu.id
  users_config_path = "${path.root}/example_users.yaml"
  cloud_init_path   = "${path.root}/example_cloud_init"
}
```

> **WARNING:** The parameter `node_storage_encryption_enabled` should be kept as `false` unless an agency for EVS is created with:
> - Agency Name = `EVSAccessKMS`
> - Agency Type = `Account`
> - Delegated Account = `op_svc_evs`
> - Permissions = `KMS Administrator` within the project

Notes:
- Please see [example_users.yaml](../../example_users.yaml) for example users_config
- Please see [example_cloud_init](../../example_cloud_init) for example cloud_init configuration
- More examples of cloud-init can be found in [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
- For complete documentation of cloud init, please see [cloud-init Documentation](https://cloudinit.readthedocs.io/en/latest/index.html)
- The jumphost module is designed to ignore changes in the node_image_id parameter. If an image update is intended,
  please use taint or destroy:
```bash
terraform destroy -target module.<module_name>.opentelekomcloud_ecs_instance_v1.jumphost_node
```
or
```bash
terraform taint module.<module_name>.opentelekomcloud_ecs_instance_v1.jumphost_node
terraform apply
```