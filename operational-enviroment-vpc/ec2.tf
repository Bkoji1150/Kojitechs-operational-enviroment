
/*# Using the module from https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
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
associate_public_ip_address = true
  tags = {
    Name        = "private_instance"
    Environment = "prod"
  }
}
*/
