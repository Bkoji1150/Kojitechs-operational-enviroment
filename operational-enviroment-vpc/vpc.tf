# Using the module from https://github.com/terraform-aws-modules/terraform-aws-vpc
locals {
  required_tags        = module.required_tags.aws_default_tags
  vpc_cidr             = var.vpc_cidr
  priv_subnet_cidr     = slice([for i in range(1, 225, 2) : cidrsubnet(local.vpc_cidr, 8, i)], 0, var.priv_subnet_count)
  pub_subnet_cidr      = slice([for i in range(0, 225, 2) : cidrsubnet(local.vpc_cidr, 8, i)], 0, var.pub_subnet_count)
  database_subnet_cidr = slice([for i in range(99, 225, 2) : cidrsubnet(local.vpc_cidr, 8, i)], 0, var.database_subnet_count)
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
  name                 = var.component_name
  cidr                 = local.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = local.priv_subnet_cidr
  public_subnets       = local.pub_subnet_cidr
  database_subnets     = local.database_subnet_cidr
  enable_dns_hostnames = true

  enable_nat_gateway = true
  enable_vpn_gateway = false
}

# APP SECURITY GROUP
