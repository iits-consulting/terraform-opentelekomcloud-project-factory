module "cloud_tracing_service" {
  source       = "./modules/cloud_tracing_service"
  bucket_name  = "${replace(var.otc_project_name, "_", "-")}-cloud-tracing-service-bucket"
  project_name = var.otc_project_name
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = "vpc-${var.context_name}-${var.stage_name}"
  subnets = {
    "subnet-${var.stage_name}" = "default_cidr"
  }
  tags = {}
}

data "opentelekomcloud_images_image_v2" "ubuntu" {
  name       = "Standard_Ubuntu_20.04_latest"
  visibility = "public"
}

module "jumphost" {
  source            = "./modules/jumphost"
  vpc_id            = module.vpc.vpc.id
  subnet_id         = values(module.vpc.subnets)[0].id
  node_name         = "jumphost-${var.context_name}-${var.stage_name}"
  node_image_id     = data.opentelekomcloud_images_image_v2.ubuntu.id
  users_config_path = "${path.root}/example_users.yaml"
  cloud_init_path   = "${path.root}/example_cloud_init"
}

module "cce_autocreation" {
  count   = var.enable_cce_autocreation ? 1 : 0
  source  = "./modules/cce_auto_creation"
  project = data.opentelekomcloud_identity_project_v3.otc_project.name
}

module "cce" {
  source = "./modules/cce"
  name   = "${var.context_name}-${var.stage_name}-cce"
  autoscaling_config = {
    nodes_max = 8
  }
  cluster_config = {
    vpc_id            = module.vpc.vpc.id
    subnet_id         = values(module.vpc.subnets)[0].id
    cluster_version   = var.cce_version
    high_availability = false
    enable_scaling    = true
  }
  node_config = {
    availability_zones = ["eu-de-03", "eu-de-01"]
    node_count         = 3
    node_flavor        = var.cce_node_spec
    node_storage_type  = "SSD"
    node_storage_size  = 100
  }
}

module "loadbalancer" {
  source       = "./modules/loadbalancer"
  stage_name   = var.stage_name
  subnet_id    = values(module.vpc.subnets)[0].subnet_id
  context_name = var.context_name
}

module "stage_secrets_to_encrypted_s3_bucket" {
  source            = "./modules/obs_secrets_writer"
  bucket_name       = "${var.context_name}-${var.stage_name}-stage-secrets"
  bucket_object_key = "terraform-secrets"
  secrets = {
    elb_id                  = module.loadbalancer.elb_id
    elb_public_ip           = module.loadbalancer.elb_public_ip
    kubectl_config          = module.cce.cluster_credentials.kubectl_config
    kubernetes_ca_cert      = module.cce.cluster_credentials.cluster_certificate_authority_data
    client_certificate_data = module.cce.cluster_credentials.client_certificate_data
    kube_api_endpoint       = module.cce.cluster_credentials.kubectl_external_server
    client_key_data         = module.cce.cluster_credentials.client_key_data
    cce_id                  = module.cce.cluster_name
    cce_name                = module.cce.cluster_id
  }
}

module "stage_secrets_from_encrypted_s3_bucket" {
  source            = "./modules/obs_secrets_reader"
  bucket_name       = "${var.context_name}-${var.stage_name}-stage-secrets"
  bucket_object_key = "terraform-secrets-test"
  required_secrets = [
    "elb_id",
    "elb_public_ip",
    "kubectl_config",
    "kubernetes_ca_cert",
    "client_certificate_data",
    "kube_api_endpoint",
    "client_key_data",
  ]
  depends_on = [module.stage_secrets_to_encrypted_s3_bucket]
}

module "rds" {
  source = "./modules/rds"
  tags   = var.tags
  name   = "${var.context_name}-${var.stage_name}-db"

  vpc_id                 = module.vpc.vpc.id
  subnet_id              = values(module.vpc.subnets)[0].id
  db_type                = "PostgreSQL"
  db_version             = "12"
  db_cpus                = "4"
  db_memory              = "16"
  db_high_availability   = true
  db_ha_replication_mode = "async"
  db_parameters = {
    max_connections = "100",
  }
}