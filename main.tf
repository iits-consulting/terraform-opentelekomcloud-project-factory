# System variables that have to be set for this example environment:
# - OS_ACCESS_KEY
# - OS_SECRET_KEY
# - OS_DOMAIN_NAME
# - OS_TENANT_NAME or OS_PROJECT_NAME

module "cloud_tracing_service" {
  source = "./modules/cloud_tracing_service"
  bucket_name = "${var.otc_project_name}-cloud-tracing-service-bucket"
}

module "ssh_keypair" {
  source       = "./modules/ssh_keypair"
  stage_name   = var.stage_name
  context_name = var.context_name
  region       = var.region
}

module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  vpc_name              = "vpc-${var.context_name}-${var.stage_name}"
  stage_name            = var.stage_name
  vpc_subnet_cidr       = var.vpc_cidr
  vpc_subnet_gateway_ip = local.vpc_subnet_gateway_ip
  tags                  = var.tags
  region                = var.region
}

module "cce_autocreation" {
  source  = "./modules/cce_auto_creation"
  project = data.opentelekomcloud_identity_project_v3.otc_project.name
}

module "cce" {
  depends_on = [
  module.cce_autocreation]
  source        = "./modules/cce"
  key_pair_id   = module.ssh_keypair.keypair_name
  stage_name    = var.stage_name
  subnet_id     = module.vpc.subnet_network_id
  vpc_flavor_id = var.cce_vpc_flavor_id
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = var.vpc_cidr
  nodes         = local.node_specs
  tags          = var.tags
  context_name  = var.context_name
}

module "loadbalancer" {
  source       = "./modules/loadbalancer"
  stage_name   = var.stage_name
  subnet_id    = module.vpc.subnet_id
  context_name = var.context_name
}
