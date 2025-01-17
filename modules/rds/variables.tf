### mandatories
data "opentelekomcloud_identity_project_v3" "current" {}

variable "name" {
  type        = string
  description = "Name of the RDS instance."
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC to create database cluster in."
}

variable "subnet_id" {
  type        = string
  description = "Id of the subnet to create database cluster in."
}

variable "db_availability_zones" {
  type        = set(string)
  description = "Availability zones for the RDS instance. One or two zones are supported for single and primary/standby instances respectively."
  default     = []
}

locals {
  valid_availability_zones = {
    eu-de = toset([
      "eu-de-01",
      "eu-de-02",
      "eu-de-03",
    ])
    eu-nl = toset([
      "eu-nl-01",
      "eu-nl-02",
      "eu-nl-03",
    ])
    eu-ch2 = toset([
      "eu-ch2a",
      "eu-ch2b",
    ])
  }

  region = data.opentelekomcloud_identity_project_v3.current.region
  default_zones = {
    eu-de  = formatlist("${local.region}%s", ["-01", "-02"])
    eu-nl  = formatlist("${local.region}%s", ["-01", "-02"])
    eu-ch2 = formatlist("${local.region}%s", ["a", "b"])
  }

  db_availability_zones = length(var.db_availability_zones) == 0 ? local.default_zones[local.region] : var.db_availability_zones
}

resource "errorcheck_is_valid" "db_availability_zones" {
  name = "Check if db_availability_zones is set up correctly."
  test = {
    assert        = length(setsubtract(local.db_availability_zones, local.valid_availability_zones[local.region])) == 0
    error_message = "Please check your availability zones. For ${local.region} the valid az's are ${jsonencode(local.valid_availability_zones[local.region])}"
  }
}

variable "db_type" {
  type        = string
  description = "RDS database product type. (MySQL, PostgreSQL or SQLServer)"
  validation {
    condition     = contains(["MySQL", "PostgreSQL", "SQLServer"], var.db_type)
    error_message = "Parameter db_type must be MySQL, PostgreSQL or SQLServer."
  }
}

variable "db_version" {
  type        = string
  description = "RDS database product version."
}

variable "db_port" {
  type        = string
  description = "Port number for accessing the database. Default ports are: 3306(MySQL), 5432(PostgreSQL) and 1433(SQLServer)"
  default     = "default"
}

locals {
  db_port_defaults = {
    MySQL      = "3306"
    PostgreSQL = "5432"
    SQLServer  = "1433"
  }
  db_port = var.db_port == "default" ? local.db_port_defaults[var.db_type] : var.db_port
}

variable "db_cpus" {
  type        = string
  description = "Number of CPU cores desired for database nodes. (default: 2)"
  default     = "2"
}

variable "db_memory" {
  type        = number
  description = "Amount of memory desired for database nodes in GB. (default: 4)"
  default     = 4
}

variable "db_high_availability" {
  type        = bool
  description = "Whether a single db instance or a high available (primary/standby) db instance is desired. (default: false)"
  default     = false
}

variable "db_ha_replication_mode" {
  type        = string
  description = "RDS data replication mode for instances with high availability (primary/standby) enabled. Defaults are async(MySQL), async(PostgreSQL) and sync(SQLServer)"
  default     = ""
}

locals {
  supported_ha_replication_modes = {
    MySQL      = ["async", "semisync"]
    PostgreSQL = ["async", "sync"]
    SQLServer  = ["sync"]
  }
  db_ha_replication_mode = var.db_high_availability ? var.db_ha_replication_mode == "" ? local.supported_ha_replication_modes[var.db_type][0] : var.db_ha_replication_mode : null
}

resource "errorcheck_is_valid" "db_ha_replication_mode_constraint" {
  name = "Check if a selected HA replication mode is supported on OTC."
  test = {
    assert        = contains(local.supported_ha_replication_modes[var.db_type], var.db_ha_replication_mode) || var.db_ha_replication_mode == "" || !var.db_high_availability
    error_message = "ERROR! Supported db_ha_replication_mode values for ${var.db_type} are [${join(", ", local.supported_ha_replication_modes[var.db_type])}]."
  }
}

variable "db_flavor" {
  type        = string
  description = "RDS Flavor string override. This parameter will override parameters for db_cpu, db_memory and db_high_availability."
  default     = ""
}

data "opentelekomcloud_rds_flavors_v3" "db_flavor" {
  count         = var.db_flavor == "" ? 1 : 0
  db_type       = var.db_type
  db_version    = var.db_version
  instance_mode = var.db_high_availability ? "ha" : "single"
}

locals {
  db_flavor = var.db_flavor == "" ? try([for f in data.opentelekomcloud_rds_flavors_v3.db_flavor[0].flavors :
  f.name if f.vcpus == var.db_cpus && f.memory == var.db_memory && alltrue([for az, status in f.az_status : !contains(var.db_availability_zones, az) || status == "normal"])][0], var.db_flavor) : var.db_flavor
}

resource "errorcheck_is_valid" "db_flavor_constraint" {
  name = "Check if a flavor is found in OTC."
  test = {
    assert        = local.db_flavor != ""
    error_message = "ERROR! No RDS Flavor is found for ${var.db_type} with ${var.db_cpus} cores and ${var.db_memory} GB memory."
  }
  depends_on = [data.opentelekomcloud_rds_flavors_v3.db_flavor]
}

variable "db_size" {
  type        = number
  description = "Amount of storage desired for the database in GB. (default: 100)"
  default     = 100
}

variable "db_storage_type" {
  type        = string
  description = "Type of storage desired for the database. (default: ULTRAHIGH)"
  default     = "ULTRAHIGH"
}

variable "db_backup_days" {
  type        = number
  description = "Retain time for automated backups in days. (default: 7)"
  default     = "7"
}

variable "db_backup_interval" {
  type        = string
  description = "UTC time window for automated database backups in \"HH:MM-HH:MM\" format. Must be at least 1 hour (default: 03:00-04:00)"
  default     = "03:00-04:00"
}

variable "db_parameters" {
  type        = map(string)
  description = "A map of additional parameters for the database instance. Check the DB Engine's documentation."
  default     = {}
}

variable "db_volume_encryption" {
  type        = bool
  description = "Enable OTC KMS volume encryption for the database volumes. (default: true)"
  default     = true
}

variable "db_volume_encryption_key_name" {
  type        = string
  description = "If KMS volume encryption is enabled for the database volumes, use this kms key name instead of creating a new one. (default: null)"
  default     = null
}

variable "sg_allowed_cidr" {
  type        = set(string)
  description = "CIDR ranges that are allowed to connect to the database. (default: <var.subnet_id.cidr>)"
  default     = []
}

data "opentelekomcloud_vpc_subnet_v1" "db_subnet" {
  id = var.subnet_id
}

variable "sg_allowed_secgroups" {
  type        = set(string)
  description = "Security groups that are allowed to connect to the database. (default: [])"
  default     = []
}

variable "sg_secgroup_id" {
  type        = string
  description = "Security group override to allow user defined security group definitions."
  default     = ""
}

variable "db_storage_alarm_threshold" {
  type        = number
  description = "CES alarm threshold (in percent) for database storage capacity. Can be disabled by setting to 0. (default: 75)"
  default     = 75
  validation {
    condition     = var.db_storage_alarm_threshold < 100 && var.db_storage_alarm_threshold >= 0
    error_message = "Parameter db_storage_alarm_threshold is in percent and must be between 0 and 100!"
  }
}

variable "db_eip_bandwidth" {
  type        = number
  description = "Bandwidth of the EIP of RDS instance, can be disabled by setting to 0. (default: 0)"
  default     = 0
}
