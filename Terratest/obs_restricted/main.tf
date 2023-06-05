module "obs_restricted" {
  source      = "../../modules/obs_restricted"
  bucket_name = var.bucket_name
  region      = var.region
  providers = {
    opentelekomcloud = opentelekomcloud.top_level_project
  }
}
