variable "otc_tenant_name" {
  type = string
}

variable "otc_project_id" {
  type = string
}

variable "aom_access_ip" {
  type        = string
  default     = "100.125.7.25"
  description = "IP address of the AOM server. This is probably specific to the region."
}

variable "region" {
  type    = string
  default = "eu-de"
}

variable "obs_domain" {
  type    = string
  default = "obs.eu-de.otc.t-systems.com"
}

locals {
  ic_agent_install_script = "http://icagent-eu-de.obs.eu-de.otc.t-systems.com/ICAgent_linux/apm_agent_install.sh"
}