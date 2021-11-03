variable "message" {
  type        = string
  description = "Message to show on output"
  default     = "Hello :)"
}

variable "instance_name" {
  type        = string
  description = "Instance Base Name"
  default     = "dummy"
}
