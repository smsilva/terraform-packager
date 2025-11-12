resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "default" {
  name                     = var.name
  resource_group_name      = azurerm_resource_group.default.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "default" {
  name                  = "files"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}
