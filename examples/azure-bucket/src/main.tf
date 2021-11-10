resource "random_string" "storage_bucket_id" {
  keepers = {
    prefix = var.name
  }

  length      = 3
  min_lower   = 1
  min_numeric = 2
  lower       = true
  special     = false
}

locals {
  storage_bucket_name = "${var.name}-${random_string.storage_bucket_id.result}"
}

resource "azurerm_resource_group" "default" {
  name     = "demo"
  location = var.location
}
