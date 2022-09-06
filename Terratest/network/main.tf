module "vpc" {
  source     = "../../modules/vpc"
  name       = "${var.context}-${var.stage}-vpc"
  cidr_block = var.vpc_cidr
  subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
  }
  tags = local.tags
}

module "snat" {
  source      = "../../modules/snat"
  name_prefix = "${var.context}-${var.stage}"
  subnet_id   = module.vpc.subnets["test-subnet"].id
  vpc_id      = module.vpc.vpc.id
}

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

module "jumphost" {
  source            = "../../modules/jumphost"
  vpc_id            = module.vpc.vpc.id
  subnet_id         = values(module.vpc.subnets)[0].id
  node_name         = "jumphost-${var.context}-${var.stage}"
  node_image_id     = data.opentelekomcloud_images_image_v2.ubuntu.id
  users_config_path = "${path.root}/../../example_users.yaml"
  cloud_init_path   = "${path.root}/../../example_cloud_init"
}


module "loadbalancer" {
  source       = "../../modules/loadbalancer"
  context_name = var.context
  subnet_id    = module.vpc.subnets["test-subnet"].subnet_id
  stage_name   = var.stage
  bandwidth    = 500
}

module "private_dns" {
  source = "../../modules/private_dns"
  vpc_id = module.vpc.vpc.id
  domain = "myprivate.endpoints"
  a_records = {
    dummy = ["127.0.0.1"]
  }
}
