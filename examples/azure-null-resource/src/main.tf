variable "name" {
  type    = string
  default = "wasp-sample-resource"
}

resource "null_resource" "default" {
  triggers = {
    name = var.name
  }
}

output "name_id" {
  value = null_resource.default.id
}

output "name_input" {
  value = var.name
}
