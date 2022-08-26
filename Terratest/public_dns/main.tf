data "opentelekomcloud_identity_project_v3" "current" {}

module "vpc" {
  source     = "../../modules/vpc"
  name       = "${var.context}-${var.stage}-vpc"
  cidr_block = var.vpc_cidr
  subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
  }
  tags = local.tags
}

module "loadbalancer" {
  source     = "../../modules/loadbalancer"
  context_name = var.context
  subnet_id = module.vpc.subnets["test-subnet"].id
}

module "public_dns" {
  source = "../../modules/public_dns"
  domain = "my_domain.com"
  email  = "my_email@my_domain.com"
  a_records = {
    my_subdomain                  = [module.loadbalancer.elb_public_ip]
    "my_domain.com"               = [module.loadbalancer.elb_public_ip]
  }
}
