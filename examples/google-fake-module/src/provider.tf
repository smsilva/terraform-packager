provider "google" {
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  backend "azurerm" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.72.0"
    }
  }
}
