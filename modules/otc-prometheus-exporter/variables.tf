variable "name_prefix" {
  type        = string
  description = "Prefix of the OTC ressources created."
}

variable "release_name" {
  default     = "otc-prometheus-exporter"
  type        = string
  description = "Name ot the release namespace."
}

variable "release_namespace" {
  type        = string
  default     = "monitoring"
  description = "Kubernetes namespace to install the chart to."
}

variable "domain_name" {
  type        = string
  description = "Domain name of the OTC"
}

variable "release_version" {
  type        = string
  description = "Release version of the chart (see releases on https://github.com/iits-consulting/otc-prometheus-exporter/tree/gh-pages)"
}
