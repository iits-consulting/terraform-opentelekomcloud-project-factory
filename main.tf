# System variables from set-env.sh needs to be set for this example

module "cloud_tracing_service" {
  source       = "./modules/cloud_tracing_service"
  bucket_name  = "${replace(var.otc_project_name, "_", "-")}-cloud-tracing-service-bucket"
  project_name = var.otc_project_name
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
  count   = var.enable_cce_autocreation ? 1 : 0
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
  cce_flavor_id = var.cce_vpc_flavor_id
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = var.vpc_cidr
  nodes         = local.node_specs
  tags          = var.tags
  context_name  = var.context_name
  cce_version   = var.cce_version
}

module "loadbalancer" {
  source       = "./modules/loadbalancer"
  stage_name   = var.stage_name
  subnet_id    = module.vpc.subnet_id
  context_name = var.context_name
}

module "cce-autoscaler" {
  source          = "./modules/cce_autoscaling"
  cce_name        = module.cce.cce_name
  ssh_key_pair_id = module.ssh_keypair.keypair_name
  project_id      = "eu-de"
  cce = {
    id     = module.cce.cce_id
    name   = module.cce.cce_name
    region = var.region
  }
  autoscaler_version = var.cce_autoscaler_version
}

module "stage_secrets_to_encrypted_s3_bucket" {
  source      = "./modules/encrypted_bucket"
  bucket_name = "${var.context_name}-${var.stage_name}-stage-secrets"
  secrets = {
    kubectlConfig               = module.cce.kubectl_config
    elbId                       = module.loadbalancer.elb_id
    elbPublicIp                 = module.loadbalancer.elb_public_ip
    kubernetesEndpoint          = module.cce.kube_api_endpoint
    kubernetesClientCertificate = base64decode(module.cce.client-certificate)
    kubernetesClientKey         = base64decode(module.cce.client-key)
    kubernetesCaCert            = base64decode(module.cce.client-key)
  }
}