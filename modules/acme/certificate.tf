resource "tls_private_key" "registration" {
  algorithm   = contains(["P256", "P384"], var.cert_registration_key_type) ? "ECDSA" : "RSA"
  ecdsa_curve = contains(["P256", "P384"], var.cert_registration_key_type) ? var.cert_registration_key_type : null
  rsa_bits    = contains(["P256", "P384"], var.cert_registration_key_type) ? null : var.cert_registration_key_type
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.registration.private_key_pem
  email_address   = var.cert_registration_email
}

resource "time_sleep" "cert_delay" {
  create_duration = "10s"
  depends_on = [
    opentelekomcloud_identity_group_membership_v3.dns_admin_membership,
    opentelekomcloud_identity_role_assignment_v3.dns_admin_to_dns_admin_group
  ]
}

resource "acme_certificate" "certificate" {
  for_each                  = var.domains
  account_key_pem           = acme_registration.registration.account_key_pem
  key_type                  = var.cert_key_type
  pre_check_delay           = 10
  common_name               = each.key
  subject_alternative_names = toset(concat([each.key], each.value))
  min_days_remaining        = var.cert_min_days_remaining
  dns_challenge {
    provider = "otc"
    config = {
      OTC_DOMAIN_NAME         = var.otc_domain_name
      OTC_IDENTITY_ENDPOINT   = "https://iam.${data.opentelekomcloud_identity_project_v3.project.region}.otc.t-systems.com/v3/auth/tokens"
      OTC_USER_NAME           = var.dns_admin_name
      OTC_PASSWORD            = random_password.dns_admin_password.result
      OTC_PROJECT_NAME        = var.otc_project_name
      OTC_PROPAGATION_TIMEOUT = 600
      OTC_POLLING_INTERVAL    = 5
      OTC_TTL                 = 300
      OTC_HTTP_TIMEOUT        = 10
    }
  }
}