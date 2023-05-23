provider "opentelekomcloud" {
  alias       = "top_level_project"
  max_retries = 100
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
  tenant_name = var.region
}
