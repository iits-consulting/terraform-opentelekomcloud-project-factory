data "opentelekomcloud_identity_project_v3" "current" {
}

resource "opentelekomcloud_dns_zone_v2" "private_zone" {
  name        = var.domain
  description = "Private DNS entries for ${var.domain}."
  ttl         = 300
  type        = "private"
  router {
    router_id     = var.vpc_id
    router_region = data.opentelekomcloud_identity_project_v3.current.region
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [email]
  }
}

resource "opentelekomcloud_dns_recordset_v2" "a_records" {
  for_each = var.a_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone A record"
  ttl         = 300
  type        = "A"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "cname_records" {
  for_each = var.cname_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone CNAME record"
  ttl         = 300
  type        = "CNAME"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "mx_records" {
  for_each = var.mx_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone MX record"
  ttl         = 300
  type        = "MX"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "aaaa_records" {
  for_each = var.aaaa_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone AAAA record"
  ttl         = 300
  type        = "AAAA"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "txt_records" {
  for_each = var.txt_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone TXT record"
  ttl         = 300
  type        = "TXT"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "ptr_records" {
  for_each = var.ptr_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone PTR record"
  ttl         = 300
  type        = "PTR"
  records     = each.value
  tags        = var.tags
}

resource "opentelekomcloud_dns_recordset_v2" "srv_records" {
  for_each = var.srv_records

  zone_id     = opentelekomcloud_dns_zone_v2.private_zone.id
  name        = each.key == var.domain ? var.domain : join(".", [trimsuffix(each.key, ".${var.domain}"), var.domain])
  description = "Private DNS zone SRV record"
  ttl         = 300
  type        = "SRV"
  records     = each.value
  tags        = var.tags
}


