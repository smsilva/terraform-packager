provider "aws" {}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
