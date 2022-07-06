data "opentelekomcloud_identity_project_v3" "current" {
}

resource "opentelekomcloud_dns_zone_v2" "public_zone" {
  name        = var.domain
  description = "Public DNS entries for ${var.domain}."
  email       = var.email
  ttl         = 3600
  type        = "public"
  tags        = var.tags
}
resource "opentelekomcloud_dns_recordset_v2" "a_records" {
  for_each = var.a_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone A record"
  ttl         = 300
  type        = "A"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "cname_records" {
  for_each = var.cname_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone CNAME record"
  ttl         = 300
  type        = "CNAME"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "mx_records" {
  for_each = var.mx_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone MX record"
  ttl         = 300
  type        = "MX"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "aaaa_records" {
  for_each = var.aaaa_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone AAAA record"
  ttl         = 300
  type        = "AAAA"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "txt_records" {
  for_each = var.txt_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone TXT record"
  ttl         = 300
  type        = "TXT"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "srv_records" {
  for_each = var.srv_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone SRV record"
  ttl         = 300
  type        = "SRV"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "ns_records" {
  for_each = var.ns_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone NS record"
  ttl         = 300
  type        = "NS"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "caa_records" {
  for_each = var.caa_records

  zone_id     = opentelekomcloud_dns_zone_v2.public_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Public DNS zone CAA record"
  ttl         = 300
  type        = "CAA"
  records     = each.value
  tags        = var.tags
}