variable "name" {
  type        = string
  description = "Prefix for all OTC resource names."
}

variable "tags" {
  type        = map(string)
  description = "Common tag set for project resources."
  default     = {}
}

variable "availability_zones" {
  type        = list(string)
  description = "Set of availability zones for the VPN gateway. (Default: [\"eu-de-01\", \"eu-de-02\"])"
  default     = ["eu-de-01", "eu-de-02"]
}

variable "flavor" {
  type        = string
  description = "The flavor of the VPN gateway. The value can be Basic, Professional1, Professional2. (Default: Basic)"
  default     = "Basic"
}

variable "attachment_type" {
  type        = string
  description = "The attachment type. The value can be vpc and er. (Default: vpc)"
  default     = "vpc"
}

variable "network_type" {
  type        = string
  description = "The network type. The value can be public and private. (Default: public)"
  default     = "public"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to which the VPN gateway is connected. This parameter is mandatory when attachment_type is vpc."
  default     = null
}

variable "local_subnets" {
  type        = set(string)
  description = "Local subnet CIDR ranges. This parameter is mandatory when attachment_type is vpc."
  default     = null
}

variable "connect_subnet" {
  type        = string
  description = "The Network ID of the VPC subnet used by the VPN gateway. This parameter is mandatory when attachment_type is vpc."
  default     = null
}

variable "er_id" {
  type        = string
  description = "The enterprise router ID to attach with to VPN gateway. This parameter is mandatory when attachment_type is er."
  default     = null
}

variable "ha_mode" {
  type        = string
  description = "The HA mode of VPN gateway. Valid values are active-active and active-standby. (Default: active-active)"
  default     = "active-active"
}

variable "access_vpc_id" {
  type        = string
  description = "The access VPC ID. The default value is the value of vpc_id."
  default     = null
}

variable "access_subnet_id" {
  type        = string
  description = "The access subnet ID. The default value is the value of connect_subnet."
  default     = null
}

variable "asn" {
  type        = number
  description = "The ASN number of BGP. The value ranges from 1 to 4,294,967,295. (Default: 64,512)"
  default     = 64512
}

variable "eip_bandwidth" {
  type        = number
  description = "The maximum bandwidth for the EIPs used by the VPN Gateway in Mbps. Only available if network_mode is public. (Default: 1000)"
  default     = 1000
}
