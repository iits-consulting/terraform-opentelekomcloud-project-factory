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

module "snat" {
  source      = "../../modules/snat"
  name_prefix = "${var.context}-${var.stage}"
  subnet_id   = module.vpc.subnets["test-subnet"].id
  vpc_id      = module.vpc.vpc.id
}

module "cce" {
  source = "../../modules/cce"
  name   = "${var.context}-${var.stage}"
  cluster_config = {
    vpc_id            = module.vpc.vpc.id
    subnet_id         = module.vpc.subnets["test-subnet"].id
    cluster_version   = "v1.21"
    high_availability = var.cluster_config.high_availability
    enable_scaling    = var.cluster_config.enable_scaling
  }
  node_config = {
    availability_zones = [
      "${var.region}-03",
      "${var.region}-01"
    ]
    node_count        = var.cluster_config.nodes_count
    node_flavor       = var.cluster_config.node_flavor
    node_storage_type = var.cluster_config.node_storage_type
    node_storage_size = var.cluster_config.node_storage_size
    node_storage_encryption_enabled = true
  }
  autoscaling_config = {
    nodes_max = var.cluster_config.nodes_max
  }
  tags = local.tags
}

module "encyrpted_secrets_bucket" {
  providers         = { opentelekomcloud = opentelekomcloud.top_level_project }
  source            = "../../modules/obs_secrets_writer"
  bucket_name       = replace(lower("${data.opentelekomcloud_identity_project_v3.current.name}-${var.context}-${var.stage}-stage-secrets"), "_", "-")
  bucket_object_key = "terraform-secrets"
  secrets = {
    kubectl_config          = module.cce.cluster_credentials.kubectl_config
    kubernetes_ca_cert      = module.cce.cluster_credentials.cluster_certificate_authority_data
    client_certificate_data = module.cce.cluster_credentials.client_certificate_data
    kube_api_endpoint       = module.cce.cluster_credentials.kubectl_external_server
    client_key_data         = module.cce.cluster_credentials.client_key_data
    cce_id                  = module.cce.cluster_id
    cce_name                = module.cce.cluster_name
  }
  tags = local.tags
}
