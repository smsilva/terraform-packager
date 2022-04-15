provider "azurerm" {
  features {}
}

provider "null" {
}

terraform {
  required_version = ">= 0.15.0, < 2.0.0"

  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.74.0, < 4.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1, < 4.0.0"
    }
  }
}
