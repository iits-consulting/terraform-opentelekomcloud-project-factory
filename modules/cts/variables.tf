variable "tags" {
  type        = map(string)
  default     = null
  description = "Common tags to add to resources that support them."
}

variable "bucket_name" {
  type        = string
  description = "OBS Bucket name to store the traces (will be created automatically)."
}

variable "file_prefix" {
  type        = string
  default     = "cts"
  description = "Object name prefix to store the traces in the OBS. Default: cts"
}

variable "cts_expiration_days" {
  type        = number
  default     = 180
  description = "How long should the data be preserved within the OBS bucket (in days). Default: 180"
}

variable "enable_trace_analysis" {
  type        = bool
  default     = true
  description = "Enables/disable trace analysis (LTS) for the tracker. Default: true"
}
