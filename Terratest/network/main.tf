module "vpc" {
  source     = "../../modules/vpc"
  name       = "${var.context}-${var.stage}-vpc"
  cidr_block = var.vpc_cidr
  subnets = {
    "subnet-0" = cidrsubnet(var.vpc_cidr, 2, 0)
    "subnet-1" = cidrsubnet(var.vpc_cidr, 2, 1)
    "subnet-2" = cidrsubnet(var.vpc_cidr, 2, 2)
    "subnet-3" = cidrsubnet(var.vpc_cidr, 2, 3)
  }
  tags = local.tags
}

module "snat" {
  source        = "../../modules/snat"
  name_prefix   = "${var.context}-${var.stage}"
  subnet_id     = module.vpc.subnets["subnet-0"].id
  network_cidrs = [var.vpc_cidr]
  vpc_id        = module.vpc.vpc.id
}

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

module "jumphost" {
  source                          = "../../modules/jumphost"
  node_storage_encryption_enabled = true
  subnet_id                       = values(module.vpc.subnets)[0].id
  node_name                       = "jumphost-${var.context}-${var.stage}"
  node_image_id                   = data.opentelekomcloud_images_image_v2.ubuntu.id
  cloud_init                      = join("\n", concat(["#cloud-config"], [for path in fileset("", "${path.root}/../../example_cloud_init/*.{yml,yaml}") : file(path)]))
}

module "loadbalancer" {
  source       = "../../modules/loadbalancer"
  context_name = var.context
  subnet_id    = module.vpc.subnets["subnet-0"].subnet_id
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
