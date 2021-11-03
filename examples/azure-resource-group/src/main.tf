resource "random_string" "instance_id" {
  keepers = {
    instance_name = var.instance_name
  }

  length      = 3
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "azurerm_resource_group" "default" {
  name     = "${var.instance_name}-${random_string.instance_id.result}"
  location = "centralus"
}

resource "null_resource" "message" {
  triggers = {
    value = var.message
  }
}
