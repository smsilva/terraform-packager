resource "random_string" "storage_bucket_id" {
  keepers = {
    prefix = var.name
  }

  length      = 3
  min_lower   = 1
  min_numeric = 2
  lower       = true
  special     = false
}

locals {
  storage_bucket_name = "${var.name}-${random_string.storage_bucket_id.result}"
}

resource "aws_s3_bucket" "default" {
  bucket = local.storage_bucket_name
  acl    = "private"
}
