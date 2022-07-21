data "opentelekomcloud_identity_project_v3" "current" {}

resource "opentelekomcloud_identity_provider_v3" "provider" {
  name        = var.otc_idp_name
  description = "Keycloak Single Sign On for OTC."
  enabled     = true
}

resource "opentelekomcloud_identity_mapping_v3" "mapping" {
  mapping_id = var.otc_idp_name
  rules      = var.otc_idp_rules
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [rules]
  }
}

resource "opentelekomcloud_identity_protocol_v3" "saml" {
  protocol    = "saml"
  provider_id = opentelekomcloud_identity_provider_v3.provider.id
  mapping_id  = opentelekomcloud_identity_mapping_v3.mapping.id


  metadata {
    domain_id = data.opentelekomcloud_identity_project_v3.current.domain_id
    metadata  = data.curl.saml_descriptor.response
  }
}

data "curl" "saml_descriptor" {
  http_method = "GET"
  uri         = "${var.keycloak_domain_name}/realms/${var.keycloak_realm}/protocol/saml/descriptor"
}
