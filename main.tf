# System variables that have to be set for this example environment:
# - OS_ACCESS_KEY
# - OS_SECRET_KEY
# - OS_DOMAIN_NAME
# - OS_TENANT_NAME or OS_PROJECT_NAME


module "keypair" {
  source     = "modules/keypair"
  stage_name = var.stage_name
}

module "vpc" {
  source                = "modules/vpc"
  vpc_cidr              = var.vpc_cidr
  vpc_name              = "vpc-${var.context_name}-${var.stage_name}"
  stage_name            = var.stage_name
  vpc_subnet_cidr       = var.vpc_cidr
  vpc_subnet_gateway_ip = var.vpc_subnet_gateway_ip
  tags                  = var.tags
}

module "cce_autocreation" {
  source   = "modules/cce_auto_creation"
  projects = [
    var.otc_project_name]
}

module "cce" {
  depends_on    = [
    module.cce_autocreation]
  source        = "modules/cce"
  key_pair_id   = module.keypair.keypair_name
  stage_name    = var.stage_name
  subnet_id     = module.vpc.subnet_network_id
  vpc_flavor_id = var.cce_vpc_flavor_id
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = var.vpc_cidr
  nodes         = local.node_spec
  tags          = var.tags
  context_name  = var.context_name
}

module "loadbalancer" {
  source     = "modules/loadbalancer"
  stage_name = var.stage_name
  subnet_id  = module.vpc.subnet_id
}