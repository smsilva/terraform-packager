variable "name" {
  type    = string
  default = "wasp-sample-resource"
}

resource "null_resource" "default" {
  triggers = {
    name = var.name
  }
}

output "name" {
  value = null_resource.default.id
}
