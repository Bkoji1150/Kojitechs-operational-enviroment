# Using the module from https://github.com/terraform-aws-modules/terraform-aws-vpc
locals {
  required_tags = module.required_tags.aws_default_tags
  vpc_cidr_sbx  = "100.0.0.0/16"
  vpc_cidr_prod = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
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

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

# APP SECURITY GROUP
