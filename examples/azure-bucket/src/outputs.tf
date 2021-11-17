output "storage_account_id" {
  value = azurerm_storage_account.default.id
}

output "primary_access_key" {
  value     = azurerm_storage_account.default.primary_access_key
  sensitive = true
}

output "secondary_access_key" {
  value     = azurerm_storage_account.default.secondary_access_key
  sensitive = true
}
