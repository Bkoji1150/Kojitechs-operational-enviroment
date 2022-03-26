# Using the module from https://github.com/terraform-aws-modules/terraform-aws-vpc
locals {
  required_tags = module.required_tags.aws_default_tags
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

  name                 = format("%s-%s-%s", var.component_name, "vpc", terraform.workspace)
  cidr                 = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, length(var.public_subnets) - length(var.public_subnets), length(var.public_subnets))
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_dns_hostnames = true

  enable_nat_gateway = true
  enable_vpn_gateway = false
  tags               = local.required_tags
}


# lookup(var.aws_account_id, terraform.workspace)

/*
# THIS VALUE FOR AMI IS FOUND IN PARAMETER STORE(SAME REGION)
data "aws_ssm_parameter" "golden_ami" {
  name = "/GoldenAMI/Linux/RedHat-7/latest"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.us-east-1.s3"
}

# associate route table with VPC endpoint
resource "aws_vpc_endpoint_route_table_association" "private_route_table_association" {
  route_table_id  = module.vpc.private_route_table_ids[0]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
*/
