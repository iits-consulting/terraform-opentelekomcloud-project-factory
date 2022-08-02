#data "opentelekomcloud_identity_project_v3" "current" {}
#
#module "vpc" {
#  source     = "../../modules/vpc"
#  name       = "${var.context}-${var.stage}-vpc"
#  cidr_block = var.vpc_cidr
#  subnets = {
#    "test-subnet" = cidrsubnet(var.vpc_cidr, 1, 0)
#  }
#  tags = local.tags
#}
#
#module "loadbalancer" {
#  source       = "../../modules/loadbalancer"
#  context_name = var.context
#  subnet_id    = module.vpc.subnets["test-subnet"].subnet_id
#  stage_name   = var.stage
#  bandwidth    = 500
#}
#
#module "snat" {
#  source      = "../../modules/snat"
#  name_prefix = "${var.context}-${var.stage}"
#  subnet_id   = module.vpc.subnets["test-subnet"].id
#  vpc_id      = module.vpc.vpc.id
#}
#
#module "public_dns" {
#  source                  = "../../modules/public_dns"
#  domain  = var.domain_name
#  email   = var.email
#  a_records = {
#    (var.domain_name)      = [module.loadbalancer.elb_public_ip]
#    "*.${var.domain_name}" = [module.loadbalancer.elb_public_ip]
#  }
#  tags = local.tags
#}
#
### DNS challenge failed: OTC API request failed with HTTP status code 401
#module "certificate" {
#  source                  = "../../modules/acme"
#  cert_registration_email = "contact@iits-consulting.de"
#  otc_domain_name         = var.domain_name
#  otc_project_name        = var.project_name
#  domains = {
#    (var.domain_name) = ["*.${var.domain_name}"]
#  }
#}
#
### Depends on module certificate
#module "waf" {
#  source                  = "../../modules/waf"
#  dns_zone_id             = var.dns_zone.id
#  domain                  = "subdomain.domain.com"
#  certificate             = module.certificate.certificate["domain.com"].certificate
#  certificate_private_key = module.certificate.certificate["domain.com"].private_key
#  server_addresses = [
#    "${var.public_ip}:443",
#  ]
#}
