# Using the module from https://github.com/terraform-aws-modules/terraform-aws-vpc

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "s3CroseAccountAcess"
  cidr            = var.vpc_cidr
  azs             = slice(data.aws_availability_zones.available.names, length(var.public_subnets) - length(var.public_subnets), length(var.public_subnets))
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

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
