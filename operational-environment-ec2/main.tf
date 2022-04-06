
#data "terraform_remote_state" "mysql_aurura_secrets" {
#  backend = "s3"
#
#  config = {
#    region = var.aws_region
#    bucket = "state.tf.aws.rdscluster.mysqlaurora.kojitechs"
#    key    = format("env:/%s/terraform.tfstate/aurora", lower(terraform.workspace))
#  }
#}

data "terraform_remote_state" "operational_environment" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "operational.vpc.tf.kojitechs"
    key    = format("env:/%s/path/env", lower(terraform.workspace))
  }
}

locals {
  #  operational_enviroment = data.terraform_remote_state.mysql_aurura_secrets.outputs
  #  mysql                  = data.aws_secretsmanager_secret_version.rds_secret_target
  operational_state = data.terraform_remote_state.operational_environment.outputs
  name              = "mi-${replace(basename(var.component_name), "_", "-")}"

  key_pair             = local.operational_state.key_pair
  ec2_instance_profile = local.operational_state.ecs_instance_profile
  vpc_id               = local.operational_state.vpc_id
  vpc_cdir             = local.operational_state.vpc_cdr
  public_subnet        = local.operational_state.public_subnets
  backend_sg           = local.operational_state.app_sg
  private_subnets      = local.operational_state.private_subnets
  public_subnets_cidrs = local.operational_state.public_subnet_cidr_block
  database_subnets     = local.operational_state.database_subnets
  private_sunbet_cidrs = local.operational_state.private_subnets_cidrs
  private_instance_sg  = local.operational_state.app_sg
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


#data "aws_secretsmanager_secret_version" "rds_secret_target" {
#  secret_id = local.operational_enviroment.aws_secrets_version.secret_id
#}


module "ec2_instance_pub" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = format("%s-%s", var.component_name, "public_instance")
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  monitoring                  = true
  key_name                    = local.key_pair
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = local.public_subnet[0]
  iam_instance_profile        = local.ec2_instance_profile
  user_data                   = file("${path.root}/template/ublic-install.sh")
}

module "private_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = format("%s-%s", var.component_name, "private_instance")
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  monitoring             = true
  key_name               = local.key_pair
  vpc_security_group_ids = [aws_security_group.app_sg1.id]
  subnet_id              = local.private_subnets[0]
  iam_instance_profile   = local.ec2_instance_profile
  user_data              = file("${path.root}/template/jumpbox-install.sh")
}

module "sprint_instance" {
  depends_on = [module.mysql_aurora]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${var.component_name}-sprint_instance"
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.xlarge"
  monitoring             = true
  key_name               = local.key_pair
  vpc_security_group_ids = [local.backend_sg]
  subnet_id              = local.private_subnets[0]
  iam_instance_profile   = local.ec2_instance_profile
  user_data = templatefile("${path.root}/template/app3-ums-install.tmpl",
    {
      endpoint    = module.mysql_aurora.db_instance_address #jsondecode(local.mysql.secret_string)["endpoint"]
      port        = 3306                                    # jsondecode(local.mysql.secret_string)["port"]
      db_name     = var.db_instance_identifier              # jsondecode(local.mysql.secret_string)["dbname"]
      db_user     = var.db_username                         #jsondecode(local.mysql.secret_string)["username"]
      db_password = var.db_password                         #jsondecode(local.mysql.secret_string)["password"]
    }
  )
}

# Create AWS RDS Database
module "mysql_aurora" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.0.0"

  identifier = local.name
  name       = var.db_instance_identifier
  username   = var.db_username
  password   = var.db_password
  port       = 3306


  multi_az               = true
  subnet_ids             = local.database_subnets
  vpc_security_group_ids = [local.backend_sg]

  engine               = "mysql"
  engine_version       = "8.0.20"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false


  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = false
  monitoring_interval                   = 0

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}
