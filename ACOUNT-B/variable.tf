variable "aws_account_id" {
  type    = string
  default = "735972722491"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "bucket" {
  type = list(any)
  default = [
    "ecs.terraform.cluster.terraform",
    "ecs.working.cluster.terraform",
    "hqr.common.database.module.kojitechs.tf",
    "operational.vpc.tf.kojitechs",
    "vpc.peering.tf.kojitechs",
    "state.tf.data-pipeline.migration.kojitechs"
  ]
}


variable "application_owner" {
  description = "Email Group for the Application owner."
  type        = string
  default     = "kojibello058@gmail.com"
}

variable "builder" {
  description = "Email for the builder of this infrastructure"
  type        = string
  default     = "kojibello058@gmail.com"
}

variable "tech_poc_primary" {
  description = "Primary Point of Contact for Technical support for this service."
  type        = string
  default     = "kojibello058@gmail.com"
}

variable "tech_poc_secondary" {
  description = "Secondary Point of Contact for Technical support for this service."
  type        = string
  default     = "kojibello058@gmail.com"
}

variable "line_of_business" {
  description = "Line of Business"
  type        = string
  default     = "Kojitechs"
}
variable "ado" {
  description = "Compainy name for this project"
  type        = string
  default     = "Kojitechs"
}
variable "tier" {
  type        = string
  description = "Canonical name of the application tier"
  default     = "APP"
}

variable "cell_name" {
  description = "Name of the ECS cluster to deploy the service into."
  type        = string
  default     = "APP"
}

variable "component_name" {
  description = "Name of the component."
  type        = string
  default     = "kojitechs-statebucket-s3-"
}
