provider "aws" {
  region                  = var.aws_region
  profile                 = "default"
  shared_credentials_file = "/Users/kojibello/.aws/credentials"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/Role_For-S3_Creation"
  }
}
