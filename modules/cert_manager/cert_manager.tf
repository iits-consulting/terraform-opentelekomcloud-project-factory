resource "helm_release" "cert-manager" {
  name                  = var.release_name
  chart                 = var.chart_name
  repository            = var.chart_repository
  version               = var.chart_version
  namespace             = var.release_namespace
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  dynamic "set" {
    for_each = toset(var.chart_set_parameter)
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
  dynamic "set_sensitive" {
    for_each = toset(var.chart_set_sensitive_parameter)
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
    }
  }
  values = concat([
    yamlencode({
      clusterIssuers = {
        email = var.email
        otcDNS = {
          region    = data.opentelekomcloud_identity_project_v3.current.region
          accessKey = opentelekomcloud_identity_credential_v3.user_aksk.access
          secretKey = opentelekomcloud_identity_credential_v3.user_aksk.secret
        }
      }
    })
  ], var.chart_values)
}
