terraform {
  required_version = ">= 0.15.1, < 2.0.0"

  backend "local" {}

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">=2.1.0"
    }
  }
}

provider "local" { 
}
