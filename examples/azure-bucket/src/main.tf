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
  storage_bucket_name = "silvios${var.name}${random_string.storage_bucket_id.result}"
}

resource "azurerm_resource_group" "default" {
  name     = "demo"
  location = var.location
}

resource "azurerm_storage_account" "default" {
  name                     = local.storage_bucket_name
  resource_group_name      = azurerm_resource_group.default.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "default" {
  name                  = "files"
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}
