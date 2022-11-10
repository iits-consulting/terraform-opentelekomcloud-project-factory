module "vpc" {
  source     = "../../modules/vpc"
  name       = "${var.context}-${var.stage}-vpc"
  cidr_block = var.vpc_cidr
  subnets = {
    "test-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
  }
  tags = local.tags
}

module "rds" {
  source = "../../modules/rds"
  tags   = local.tags
  name   = "${var.context}-${var.stage}-db"

  vpc_id                 = module.vpc.vpc.id
  subnet_id              = values(module.vpc.subnets)[0].id
  db_type                = "PostgreSQL"
  db_version             = "12"
  db_ha_replication_mode = "async"
  db_parameters = {
    max_connections = "100",
  }
}
