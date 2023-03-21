variable "name" {
  type        = string
  description = "Bucket Name (Storage Account). If set as 'generic-bucket-1' then you should get something like: generic-bucket-1-x5f"
  default     = "tfpackagerfiles"
}

variable "location" {
  type        = string
  description = "Azure Storage Account Location"
  default     = "centralus"
}

variable "resource_group_name" {
  type        = string
  description = "Azure Storage Account Resource Group Name"
  default     = "tfpackager-example-storage-account"
}
