provider "aws" {
  region  = var.aws_region
  profile = "default"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/Role_For-S3_Creation"
  }
  default_tags {
    tags = local.default_tags
  }
}

terraform {
  required_version = ">=1.1.5"

  backend "s3" {
    bucket = "state.buckects.contents"
    key    = "path/env"
    region = "us-east-1"
  }
}
