
resource "aws_security_group" "web_sg" {
  vpc_id      = local.vpc_id
  name        = format("%s-%s", var.component_name, "app_sg1", )
  description = "Allow inbound traffic from publich ssh instance to app_sg1"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_security_group" "app_sg" {
  vpc_id = local.vpc_id

  ingress {
    description     = "For port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  ingress {
    description = "MySQL TLS from rds"
    from_port   = jsondecode(local.mysql.secret_string)["port"]
    to_port     = jsondecode(local.mysql.secret_string)["port"]
    protocol    = "tcp"
    cidr_blocks = [local.private_sunbet_cidrs[0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
