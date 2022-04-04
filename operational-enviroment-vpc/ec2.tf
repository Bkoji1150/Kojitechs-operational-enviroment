
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

data "terraform_remote_state" "mysql_aurura_secrets" {
  backend = "s3"

  config = {
    region = var.aws_region
    bucket = "state.tf.aws.rdscluster.mysqlaurora.kojitechs"
    key    = format("env:/%s/terraform.tfstate/aurora", lower(terraform.workspace))
  }
}

data "aws_secretsmanager_secret_version" "rds_secret_target" {
  secret_id = "arn:aws:secretsmanager:us-east-1:674293488770:secret:hqr-common-database-master-secret-sbx20220402110132801000000002-f1kTlm"
}

locals {
  operational_enviroment = data.terraform_remote_state.mysql_aurura_secrets.outputs
  mysql                  = data.aws_secretsmanager_secret_version.rds_secret_target
}

module "ec2_instance_pub" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name                        = format("%s-%s", var.component_name, "public_instance")
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  monitoring                  = true
  key_name                    = aws_key_pair.keypair.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.ec2profile.name
  user_data                   = file("${path.root}/template/ublic-install.sh")
}

module "private_instance" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name                   = format("%s-%s", var.component_name, "private_instance")
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  monitoring             = true
  key_name               = aws_key_pair.keypair.id
  vpc_security_group_ids = [aws_security_group.app_sg1.id, aws_security_group.web_sg.id]
  subnet_id              = module.vpc.database_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.ec2profile.name
  user_data              = file("${path.root}/jumpbox-install.sh")
}

#module "sprint_instance" {
#  depends_on = [module.vpc]
#  source     = "terraform-aws-modules/ec2-instance/aws"
#
#  name = "${var.component_name}-sprint_instance"
#  ami                    = "ami-0c02fb55956c7d316"
#  instance_type          = "t2.xlarge"
#  monitoring             = true
#  key_name               = aws_key_pair.keypair.id
#  vpc_security_group_ids = [aws_security_group.app_sg3.id]
#  subnet_id              = module.vpc.database_subnets[0]
#  iam_instance_profile   = aws_iam_instance_profile.ec2profile.name
#  user_data = templatefile("${path.root}/template/app3-ums-install.tmpl",
#    {
#      endpoint    = jsondecode(local.mysql.secret_string)["endpoint"]
#      port        = jsondecode(local.mysql.secret_string)["port"]
#      db_name     = jsondecode(local.mysql.secret_string)["dbname"]
#      db_user     = jsondecode(local.mysql.secret_string)["username"]
#      db_password = jsondecode(local.mysql.secret_string)["password"]
#    }
#  )
#}
