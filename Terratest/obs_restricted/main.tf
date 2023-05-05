module "obs_restricted_eu_nl" {
  source      = "../../modules/obs_restricted"
  bucket_name = var.bucket_name
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }
}

module "obs_restricted_eu_de" {
  source      = "../../modules/obs_restricted"
  bucket_name = var.bucket_name
  providers = {
    opentelekomcloud = opentelekomcloud.de
  }
}
