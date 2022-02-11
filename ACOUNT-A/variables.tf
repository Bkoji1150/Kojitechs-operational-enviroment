variable "aws_account_id" {
  type = string
}
variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list
}

variable "public_subnets" {
  type = list
}

variable "key_name" {
  type    = string
  default = "endptkey"
}

variable "public_key_path" {
  type    = string
  default = "/Users/kojibello/.ssh/s3_key.pub"
}
