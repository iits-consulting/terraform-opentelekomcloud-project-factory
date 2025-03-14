variable "hide_fields" {
  type = list(string)
  default = [
    "apiVersion",
    "kind",
    "metadata",
    "spec",
  ]
  description = "Hide the diff output of terraform by marking it as sensitive. Useful for less cluttered terraform output. See https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/kubectl_manifest#sensitive-fields for details."
}

variable "server_side_apply" {
  type        = bool
  default     = true
  description = "Apply using server-side-apply method."
}

variable "force_conflicts" {
  type        = bool
  default     = true
  description = "Apply using force-conflicts flag."
}

variable "apply_only" {
  type        = bool
  default     = true
  description = "Apply only, prevents destruction of CRDs."
}

variable "force_new" {
  type        = bool
  default     = false
  description = "Forces delete & create of resources if the CRD manifest changes."
}

variable "kube_version" {
  type        = string
  default     = "1.29.2" // Latest CCE
  description = "Select the kubernetes cluster version for charts that require version validation."
}


variable "charts" {
  type = map(object({
    repository = string
    version    = string
    enabled    = optional(bool, true)
    values     = optional(list(string), [""])
    set = optional(list(object({
      name  = string
      value = string
    })), [])
    set_sensitive = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default     = {}
  description = "A map of additional charts and their parameters to extract CRDs from. (Please ensure that the CRD flags are set to true for the charts)"
}

variable "default_chart_overrides" {
  type        = map(any)
  default     = {}
  description = "Overrides for the default charts. Supported parameters are: repository, version, enabled, values, set and set_sensitive. (see https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template)"
}

locals {
  default_charts = {
    cert-manager = {
      repository = "https://charts.iits.tech"
      version    = "1.16.1"
      enabled    = true
      values     = [""]
      set = [{
        name  = "cert-manager.installCRDs"
        value = true
      }]
      set_sensitive = []
    }
    traefik = {
      repository = "https://charts.iits.tech"
      version    = "34.2.0"
      enabled    = true
      values     = [""]
      set = [{
        name  = "traefik.metrics.prometheus.disableAPICheck"
        value = true
      }]
      set_sensitive = []
    }
    kyverno = {
      repository = "https://charts.iits.tech"
      version    = "2.2.2"
      enabled    = true
      values     = [""]
      set = [{
        name  = "kyverno.crds.install"
        value = true
      }]
      set_sensitive = []
    }
    prometheus-stack = {
      repository = "https://charts.iits.tech"
      version    = "62.6.0"
      enabled    = true
      values     = [""]
      set = [{
        name  = "prometheusStack.crds.enabled"
        value = true
      }]
      set_sensitive = []
    }
  }
  charts_merged = merge({ for chart, params in local.default_charts : chart => merge(params, lookup(var.default_chart_overrides, chart, null)) }, var.charts)
}
