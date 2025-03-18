locals {
  rds_ces_metric_dimensions = {
    MySQL      = "rds_cluster_id"
    PostgreSQL = "postgresql_cluster_id"
    SQLServer  = "rds_cluster_sqlserver_id"
  }
  metrics = {
    cpu = {
      threshold       = var.db_cpu_alarm_threshold
      metric_api_name = "rds001_cpu_util"
    }
    memory = {
      threshold       = var.db_memory_alarm_threshold
      metric_api_name = "rds002_mem_util"
    }
    storage = {
      threshold       = var.db_storage_alarm_threshold
      metric_api_name = "rds039_disk_util"
    }
  }
}

resource "opentelekomcloud_ces_alarmrule" "db_ces_alarms" {
  for_each    = { for name, metric in local.metrics : name => metric if metric.threshold > 0 }
  alarm_level = 2
  alarm_name  = replace("${var.name}-${each.key}-alarm", "-", "_")
  metric {
    namespace   = "SYS.RDS"
    metric_name = each.value.metric_api_name
    dimensions {
      name  = local.rds_ces_metric_dimensions[var.db_type]
      value = opentelekomcloud_rds_instance_v3.db_instance.id
    }
  }
  condition {
    period              = 1
    filter              = "average"
    comparison_operator = ">"
    value               = each.value.threshold
    unit                = "%"
    count               = 3
    alarm_frequency     = 86400
  }
  alarm_action_enabled = false
}
