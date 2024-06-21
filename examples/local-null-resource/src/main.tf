variable "name" {
  type    = string
  default = "wasp-sample-resource"
}

resource "null_resource" "default" {
  triggers = {
    name = var.name
  }
}

output "id" {
  value = null_resource.default.id
}

output "name" {
  value = var.name
}

output "composite" {
  value = {
    id = null_resource.default.id
    name = var.name
  }
}
