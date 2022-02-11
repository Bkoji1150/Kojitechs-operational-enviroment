
# Using the module from https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "baston-public-server"
  ami                         = data.aws_ssm_parameter.golden_ami.value # Golden iam from parameter store with aws cli baked
  instance_type               = "t2.micro"
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.My_VPC_Security_Group_Public.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name        = "Baston-Server"
    Environment = "prod"
  }
}


module "ec2_private_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "private_instance"
  ami                    = data.aws_ssm_parameter.golden_ami.value # Golden iam from parameter store with aws cli baked
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.My_VPC_Security_Group_Private.id]
  subnet_id              = module.vpc.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.ec2profile.name

  tags = {
    Name        = "private_instance"
    Environment = "prod"
  }
}

# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group_Private" {
  vpc_id      = module.vpc.vpc_id
  name        = "My VPC Security Group Private"
  description = "My VPC Security Group Private"
  ingress {
    security_groups = [aws_security_group.My_VPC_Security_Group_Public.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name = "My VPC Security Group Private"
  }
}

resource "aws_security_group" "My_VPC_Security_Group_Public" {
  vpc_id      = module.vpc.vpc_id
  name        = "My VPC Security Group Public"
  description = "My VPC Security Group Public"
  ingress {
    cidr_blocks = ["71.163.242.34/32"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["71.163.242.34/32"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = [module.vpc.private_subnets_cidr_blocks[0]]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name = "My VPC Security Group Public"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "s3_key"
  public_key = file(var.public_key_path)
}
