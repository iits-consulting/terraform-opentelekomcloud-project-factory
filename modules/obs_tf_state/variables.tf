variable "bucket_name" {
  description = "The bucket name where the encrypted tf file should be stored"
}
variable "region" {}
variable "tags" {
  default     = null
  type        = map(string)
  description = "Resource tags that you can utilize in your cloud budget controlling."
}
variable "pending_days" {
  default     = 7
  type        = number
  description = "The number of days that a deleted key should be kept in case it is needed again. After this time, it is deleted permanently."
}