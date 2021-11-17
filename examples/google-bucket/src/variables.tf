variable "name" {
  type        = string
  description = "Bucket Name. If set as 'generic-bucket-1' then you should get something like: generic-bucket-1-x5f"
  default     = "wasp-files"
}

variable "location" {
  type        = string
  description = "Google Cloud Region"
  default     = "southamerica-east1"
}
