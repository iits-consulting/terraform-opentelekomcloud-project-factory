resource "helm_release" "otc-prometheus-exporter" {
  name       = var.release_name
  repository = "https://iits-consulting.github.io/otc-prometheus-exporter/"
  chart      = "otc-prometheus-exporter"
  version    = var.release_version

  namespace             = var.release_namespace
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true

  values = [yamlencode({
    deployment = {
      env = {
        OS_ACCESS_KEY  = opentelekomcloud_identity_credential_v3.user_aksk.access
        OS_SECRET_KEY  = opentelekomcloud_identity_credential_v3.user_aksk.secret
        OS_PROJECT_ID  = data.opentelekomcloud_identity_project_v3.project.id
        OS_DOMAIN_NAME = var.domain_name
      }
    }
    serviceMonitor = {
      labels = {
        release = "kube-prom-stack"
      }
    }
  })]
}
