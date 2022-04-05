## Module to auto create VPC and multiple Subnet

Usage example:
```hcl
module "vpc" {
  source                = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
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
  source            = "iits-consulting/project-factory/opentelekomcloud//modules/jumphost"
  vpc_id            = module.vpc.vpc.id
  subnet_id         = values(module.vpc.subnets)[0].id
  node_name         = "jumphost-demo"
  node_image_id     = data.opentelekomcloud_images_image_v2.ubuntu.id
  users_config_path = "${path.root}/example_users.yaml"
  cloud_init_path   = "${path.root}/example_cloud_init"
}
```
Notes:
- Please see [example_users.yaml](../../example_users.yaml) for example users_config
- Please see [example_cloud_init](../../example_cloud_init) for example cloud_init configuration
- More examples of cloud-init can be found in [Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)
- For complete documentation of cloud init, please see [cloud-init Documentation](https://cloudinit.readthedocs.io/en/latest/index.html)
