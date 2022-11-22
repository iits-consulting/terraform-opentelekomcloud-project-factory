provider "opentelekomcloud" {
  alias       = "nl"
  max_retries = 100
  auth_url    = "https://iam.eu-nl.otc.t-systems.com/v3"
}

provider "opentelekomcloud" {
  alias       = "de"
  max_retries = 100
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
}