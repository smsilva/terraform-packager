terraform {
  required_version = ">= 1.1.9, < 2.0.0"

  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.74.0"
    }
  }
}

provider "azurerm" {
  features {}
}
