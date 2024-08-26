locals {
  virtual_network_name  = "tfp-example"
  virtual_network_cidrs = ["10.244.0.0/14"]
  virtual_network_subnets = [
    { cidr = "10.246.0.0/16", name = "aks" },
  ]
}

resource "azurerm_resource_group" "default" {
  name     = local.virtual_network_name
  location = "centralus"
}

module "vnet" {
  source = "git@github.com:smsilva/azure-network.git//src/vnet?ref=3.0.6"

  name                = local.virtual_network_name
  cidrs               = local.virtual_network_cidrs
  subnets             = local.virtual_network_subnets
  resource_group_name = azurerm_resource_group.default.name

  depends_on = [
    azurerm_resource_group.default
  ]
}

module "storage" {
  source = "git@ssh.dev.azure.com:v3/smsilva/azure-platform/azure-storage-account//src?ref=development"

  name           = "tfpexample"
  resource_group = azurerm_resource_group.default
}

output "something" {
  value = "nothing"
}
