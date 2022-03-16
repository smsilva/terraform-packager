locals {
  storage_bucket_name = "silvios${var.name}"
}

resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
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
