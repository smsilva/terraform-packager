terraform {
  backend "local" {}

  required_version = ">= 1.1.9, < 2.0.0"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 2.0.0, < 3.0.0"
    }
  }
}

provider "fastly" {
}
