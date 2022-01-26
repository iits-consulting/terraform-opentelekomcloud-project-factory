variable "project" {
  description = "Project parameters"
  type = object({
    context  = string // Project name or context
    customer = string // A customer short name indicator (e.g. TSIDEMO)
    domain   = string // OTC domain for the project
    region   = string // OTC region for the project (eu-de or eu-nl)
  })
}

locals {
  context = replace(lower(var.project.context), "_", "-")
  common_tags = {
    PROJECT  = upper(var.project.context)
    CUSTOMER = upper(var.project.customer)
  }
}