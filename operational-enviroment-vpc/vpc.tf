# Using the module from https://github.com/terraform-aws-modules/terraform-aws-vpc
locals {
  required_tags = module.required_tags.aws_default_tags
  vpc_cidr_sbx  = "100.0.0.0/16"
  vpc_cidr_prod = "10.0.0.0/16"
}

module "required_tags" {
  source = "git::git@github.com:Bkoji1150/kojitechs-tf-aws-required-tags.git"

  line_of_business        = var.line_of_business
  ado                     = var.ado
  tier                    = var.tier
  operational_environment = upper(terraform.workspace)
  tech_poc_primary        = var.tech_poc_primary
  tech_poc_secondary      = var.tech_poc_secondary
  application             = "DATA_VPC"
  builder                 = var.builder
  application_owner       = var.application_owner
  vpc                     = var.cell_name
  cell_name               = var.cell_name
  component_name          = format("%s-%s", var.component_name, terraform.workspace)
}


data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version              = "~> 3.0"
  name                 = format("%s-%s-%s", var.component_name, "vpc", terraform.workspace)
  cidr                 = terraform.workspace == "sbx" ? local.vpc_cidr_sbx : local.vpc_cidr_prod
  azs                  = slice(data.aws_availability_zones.available.names, length(var.public_subnets) - length(var.public_subnets), length(var.public_subnets))
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  database_subnets     = var.db_subnets_cidr
  enable_dns_hostnames = true

  enable_nat_gateway = true
  enable_vpn_gateway = false

}

resource "aws_s3_bucket" "lambda_bucket" {
  count  = terraform.workspace == "sbx" ? length(var.lambda_buckets) : 0
  bucket = var.lambda_buckets[count.index]

}

resource "aws_s3_bucket_policy" "allow_lambda_bucketaccount" {
  count  = terraform.workspace == "sbx" ? length(var.lambda_buckets) : 0
  bucket = aws_s3_bucket.lambda_bucket[0].id
  policy = data.aws_iam_policy_document.allow_access_lambda_bucket_account[count.index].json
}


data "aws_iam_policy_document" "allow_access_lambda_bucket_account" {
  count = terraform.workspace == "sbx" ? length(var.lambda_buckets) : 0

  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::735972722491:role/Role_For-S3_Creation",
      "arn:aws:iam::674293488770:role/Role_For-S3_Creation"]
    }

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    resources = [
      aws_s3_bucket.lambda_bucket[0].arn,
      join("/", [aws_s3_bucket.lambda_bucket[0].arn, "*"])
    ]
  }

}
