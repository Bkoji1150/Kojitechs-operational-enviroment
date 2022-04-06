
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "db_subnet_ids" {
  value = module.vpc.database_subnet_group
}

output "vpc_cdr" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.public_subnets_cidr_blocks
}


output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidrs" {
  value = module.vpc.private_subnets_cidr_blocks
}
# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "db_subnets_names" {
  value = module.vpc.database_subnet_group_name
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "rout_table" {
  value = module.vpc.default_route_table_id
}
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "database_cidr" {
  value = module.vpc.database_subnets_cidr_blocks
}
output "route_table_id" {
  description = "List of IDs of route table id"
  value       = module.vpc.vpc_main_route_table_id
}

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

output "app_sg" {
  description = "App security group created by the operational environment"
  value       = aws_security_group.app_sg.id
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ec2profile.name
}
output "key_pair" {
  value = aws_key_pair.keypair.id
}
