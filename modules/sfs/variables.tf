variable "volume_name" {
  type        = string
  description = "Volume name for the SFS Turbo resource."
}

variable "size" {
  type        = number
  default     = 500
  description = "Size of the SFS volume in GB. (Default: 500)"
}

variable "share_type" {
  type        = string
  default     = "STANDARD"
  description = "Filesystem type of the SFS volume. (Default: STANDARD)"
}

variable "availability_zone" {
  type        = string
  default     = "eu-de-01"
  description = "Availability zone for the SFS Turbo resource."
}

variable "vpc_id" {
  type        = string
  description = "VPC id where the SFS volume will be created in."
}

variable "subnet_id" {
  type        = string
  description = "Subnet network id where the SFS volume will be created in."
}

variable "kms_key_id" {
  type        = string
  description = "Existing KMS Key ID for server side encryption if one is already created."
  default     = null
}

variable "kms_key_create" {
  type        = bool
  description = "Existing KMS Key ID if one is already created."
  default     = true
}

variable "backup_enabled" {
  type        = bool
  default     = true
  description = "Enable SFS volume backups via CBR Vault."
}

variable "backup_size" {
  type        = number
  default     = 1000
  description = "Size of the SFS volume backup vault in GB."
}

variable "backup_trigger_pattern" {
  type        = list(string)
  default     = ["FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU;BYHOUR=00;BYMINUTE=00"]
  description = "Backup trigger pattern to define backup schedule (iCalender RFC 2445). See https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/1.35.7/docs/resources/cbr_policy_v3#trigger_pattern for details."
}

variable "backup_retention_days" {
  type        = number
  default     = 13
  description = "Retention duration of SFS volume backups in days."
}