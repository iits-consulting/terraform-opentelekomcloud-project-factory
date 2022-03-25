##Module to auto create VPC and multiple Subnet

Usage example (see [users.yaml](../../users.yaml) for example users_config)
```hcl
module "vpc" {
  source                = "iits-consulting/project-factory/opentelekomcloud//modules/vpc"
  version               = "2.0.0-alpha"
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
  users_config_path = "${path.root}/users.yaml"
}
```