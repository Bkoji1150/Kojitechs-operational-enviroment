
terraform {
  required_version = "~> 1.1.5"
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
}
# local.prod.
terraform {

  backend "s3" {
    bucket = "vpc.peering.tf.kojitechs"
    key    = "terraform.state"
    region = "us-east-1"
  }
}
provider "aws" {
  profile = "default"
  region  = var.region
}
data "terraform_remote_state" "operational_prod" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "operational.vpc.tf.kojitechs"
    key    = format("env:/%s/path/env", "prod")
  }
}

data "terraform_remote_state" "operational_sbx" {
  backend = "s3"

  config = {
    region = var.region
    bucket = "operational.vpc.tf.kojitechs"
    key    = format("env:/%s/path/env", "sbx")
  }
}


locals {
  required_tags                = module.required_tags.aws_default_tags
  operational_environment_prod = data.terraform_remote_state.operational_prod.outputs
  operational_environment_sbx  = data.terraform_remote_state.operational_sbx.outputs
  prod_public_subnets_ids      = local.operational_environment_prod.public_subnets
  sbx_public_subnets_ids       = local.operational_environment_sbx.public_subnets
  prod_route_id                = local.operational_environment_prod.route_table_id
  sbx_route_id                 = local.operational_environment_sbx.route_table_id
  owner_vpc_id                 = local.operational_environment_prod.vpc_id
  accepter_account_id          = "674293488770"
}

provider "aws" {
  alias   = "accepter"
  region  = var.aws_region
  profile = "default"

  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.aws_account_id, terraform.workspace)}:role/Role_For-S3_Creation"
  }
  default_tags {
    tags = local.required_tags
  }
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


module "vpc_peering_cross_account" {
  source = "cloudposse/vpc-peering-multi-account/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  namespace = terraform.workspace
  stage     = "dev"
  name      = "cluster"

  requester_aws_assume_role_arn             = "arn:aws:iam::${lookup(var.aws_account_id, terraform.workspace)}:role/Role_For-S3_Creation"
  requester_region                          = "us-east-1"
  requester_vpc_id                          = local.operational_environment_prod.vpc_id
  requester_allow_remote_vpc_dns_resolution = true

  accepter_aws_assume_role_arn             = "arn:aws:iam::674293488770:role/Role_For-S3_Creation"
  accepter_region                          = "us-east-1"
  accepter_vpc_id                          = local.operational_environment_sbx.vpc_id
  accepter_allow_remote_vpc_dns_resolution = true
}
/*
resource "aws_vpc_peering_connection" "owner" {
  vpc_id = local.operational_environment_prod.vpc_id
  peer_vpc_id   = local.operational_environment_sbx.vpc_id
  peer_owner_id = local.accepter_account_id
  auto_accept                       = "false"

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = "aws.accepter"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.owner.id}"
  auto_accept               = true
  tags = {
    Side  = "Accepter"
  }
}

resource "aws_route" "owner" {
  count = length(local.prod_route_id)
  route_table_id            = local.prod_route_id
  destination_cidr_block    = local.operational_environment_sbx.vpc_cidr_block
  vpc_peering_connection_id = local.accepter_account_id
}

resource "aws_route" "accepter" {
  provider = "aws.accepter"
  count = length(local.operational_environment_sbx.vpc_id)
  route_table_id            = local.operational_environment_sbx.route_table_id
  destination_cidr_block    =local.operational_environment_prod.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
}
*/
