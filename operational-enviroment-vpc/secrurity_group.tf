resource "aws_security_group" "web_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = format("%s-%s", var.component_name, "web_sg")
  description = "Allow inbound traffic to ${format("%s-%s", var.component_name, terraform.workspace)} ec2"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app_sg1" {
  vpc_id      = module.vpc.vpc_id
  name        = format("%s-%s", var.component_name, "app_sg1", )
  description = "Allow inbound traffic from publich ssh instance to app_sg1"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app_sg3" {
  vpc_id      = module.vpc.vpc_id
  name        = format("%s-%s", var.component_name, "app_sg3", )
  description = "Allow inbound traffic from publich ssh instance to app_sg3"
  ingress {
    description = "Allow traffic to port from port ${var.app_port}"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
