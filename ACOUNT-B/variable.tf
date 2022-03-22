variable "aws_account_id" {
  type    = string
  default = "735972722491"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "bucket" {
  type    = list(any)
  default = ["ecs.terraform.cluster.terraform", "ecs.working.cluster.terraform"]
}
