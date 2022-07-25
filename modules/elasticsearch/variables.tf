### mandatories
variable "name" {
  type        = string
  description = "Name of the ES instance."
}

variable "vpc_id" {
  type        = string
  description = "Id of the VPC to create elasticsearch instance in."
}

variable "subnet_id" {
  type        = string
  description = "Id of the subnet to create elasticsearch instance in."
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources"
  default     = {}
}

variable "sg_secgroup_id" {
  type        = string
  description = "Security group override to allow user defined security group definitions."
}

variable "es_availability_zones" {
  type        = list(string)
  description = "Availability zones for the elasticsearch instance."
  default     = ["eu-de-01", "eu-de-02", "eu-de-03"]
}

variable "es_version" {
  type        = string
  description = "ES product version."
  default     = "7.6.2"
  validation {
    condition     = contains(["7.6.2", "7.9.3"], var.es_version)
    error_message = "The es_version value must be 7.6.2 or 7.9.3"
  }
}

variable "es_flavor" {
  type        = string
  description = "ES Flavor string."
  default     = "css.medium.8"
}

variable "es_storage_size" {
  type        = number
  description = "Amount of storage desired for elasticsearch in GB. Must be a multiple of 4 and 10. (default: 40)"
  default     = 40
}

variable "es_storage_type" {
  type        = string
  description = "Type of storage desired for the elasticsearch instance. Allowed values are COMMON (SATA), HIGH (SAS) or ULTRAHIGH (SSD) (default: COMMON)"
  default     = "COMMON"
  validation {
    condition     = contains(["COMMON", "HIGH", "ULTRAHIGH"], var.es_storage_type)
    error_message = "Parameter es_storage_type must be one of COMMON, HIGH or ULTRAHIGH."
  }
}

variable "es_volume_encryption" {
  type        = bool
  description = "Enable OTC KMS volume encryption for the elasticsearch volumes. (default: true)"
  default     = true
}

data "opentelekomcloud_vpc_subnet_v1" "subnet_1" {
  id = var.subnet_id
}

