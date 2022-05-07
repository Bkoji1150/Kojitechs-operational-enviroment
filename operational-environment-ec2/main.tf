
data "terraform_remote_state" "mysql_aurura_secrets" {
  backend = "s3"

  config = {
    region = var.aws_region
    bucket = "state.tf.aws.rdscluster.mysqlaurora.kojitechs"
    key    = format("env:/%s/terraform.tfstate/aurora", lower(terraform.workspace))
  }
}

data "terraform_remote_state" "operational_environment" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "operational.vpc.tf.kojitechs"
    key    = format("env:/%s/path/env", lower(terraform.workspace))
  }
}

data "aws_secretsmanager_secret_version" "rds_secret_target" {
  secret_id = local.operational_enviroment.aws_secrets_version.secret_id
}


locals {
  operational_enviroment = data.terraform_remote_state.mysql_aurura_secrets.outputs
  mysql                  = data.aws_secretsmanager_secret_version.rds_secret_target
  operational_state      = data.terraform_remote_state.operational_environment.outputs
  secretsmanager_secrets = data.terraform_remote_state.mysql_aurura_secrets.outputs.secretsmanager_secrets
  key_pair               = local.operational_state.key_pair
  ec2_instance_profile   = local.operational_state.ecs_instance_profile
  vpc_id                 = local.operational_state.vpc_id
  public_subnet          = local.operational_state.public_subnets
  private_subnets        = local.operational_state.private_subnets
  private_sunbet_cidrs   = local.operational_state.private_subnets_cidrs
}


module "required_tags" {
  source = "git::https://github.com/Bkoji1150/kojitechs-tf-aws-required-tags.git"

  line_of_business        = var.line_of_business
  ado                     = var.ado
  tier                    = var.tier
  operational_environment = upper(terraform.workspace)
  tech_poc_primary        = var.tech_poc_primary
  tech_poc_secondary      = var.tech_poc_secondary
  application             = "rds_database_Aurora_cluster"
  builder                 = var.builder
  application_owner       = var.application_owner
  vpc                     = var.cell_name
  cell_name               = var.cell_name
  component_name          = format("%s-%s", var.component_name, terraform.workspace)
}

module "private_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = format("%s-%s", var.component_name, "private_instance")
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  monitoring             = true
  key_name               = local.key_pair
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = local.public_subnet[0]
  iam_instance_profile   = local.ec2_instance_profile
  user_data              = file("${path.root}/template/jumpbox-install.sh")
}

module "sprint_instance" {
  count  = 2
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${var.component_name}-sprint_instance"
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.xlarge"
  monitoring             = true
  key_name               = local.key_pair
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = local.private_subnets[0]
  iam_instance_profile   = local.ec2_instance_profile
  user_data = templatefile("${path.root}/template/app3-ums-install.tmpl",
    {
      endpoint    = jsondecode(local.mysql.secret_string)["endpoint"]
      port        = jsondecode(local.mysql.secret_string)["port"]
      db_name     = jsondecode(local.mysql.secret_string)["dbname"]
      db_user     = jsondecode(local.mysql.secret_string)["username"]
      db_password = jsondecode(local.mysql.secret_string)["password"]
    }
  )
}
