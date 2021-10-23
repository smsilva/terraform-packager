provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 0.15.0, < 2.0.0"

  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.74.0"
    }
  }
}
