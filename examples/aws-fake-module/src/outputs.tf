variable "name" {
  type    = string
  default = "some value here"
}

output "message" {
  value = "input variable name value: ${var.name}"
}

output "something" {
  value = "something message"
}
