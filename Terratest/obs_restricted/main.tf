module "obs_restricted_eu_nl" {
  source = "../../modules/obs_restricted"
  providers = {
    opentelekomcloud = opentelekomcloud.nl
  }
}

module "obs_restricted_eu_de" {
  source = "../../modules/obs_restricted"
  providers = {
    opentelekomcloud = opentelekomcloud.de
  }
}