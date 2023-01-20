provider "opentelekomcloud" {
  max_retries = 100
}

provider "opentelekomcloud" {
  tenant_name = var.region
  alias       = "top_level_project"
  max_retries = 100
}