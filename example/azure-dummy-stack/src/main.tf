resource "random_string" "instance_id" {
  keepers = {
    instance_name = var.instance_name
  }

  length      = 3
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "null_resource" "message" {
  triggers = {
    value = var.message
  }
}
