variable "email" {
  type        = string
  description = "E-Mail to use for the ACME Registration and DNS management."
}

variable "username" {
  type        = string
  default     = "cert-manager-dns-admin"
  description = "Desired username for cert-manager DNS administrator user."
}

variable "release_name" {
  type        = string
  default     = "cert-manager"
  description = "Name the helm release."
}

variable "release_namespace" {
  type        = string
  default     = "cert-manager"
  description = "Namespace for the chart releases."
}

variable "chart_repository" {
  type        = string
  default     = "https://charts.iits.tech"
  description = "Chart repository of the IITS cert-manager chart."
}

variable "chart_name" {
  type        = string
  default     = "cert-manager"
  description = "Name of the IITS cert-manager chart."
}

variable "chart_version" {
  type        = string
  default     = "1.16.1"
  description = "Chart version of the IITS cert-manager chart."
}

variable "chart_values" {
  type        = list(string)
  default     = []
  description = "Override the values of the IITS cert-manager chart using value files."
}

variable "chart_set_parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Override the values of the IITS cert-manager chart using set."
}


variable "chart_set_sensitive_parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Override the values of the IITS cert-manager chart using set_sensitive."
}
