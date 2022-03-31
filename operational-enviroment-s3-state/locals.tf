locals {
  default_tags = {
    line_of_business        = var.line_of_business
    ado                     = var.ado
    tier                    = var.tier
    operational_environment = upper(terraform.workspace)
    tech_poc_primary        = var.tech_poc_primary
    tech_poc_secondary      = var.tech_poc_secondary
    application             = "DATA_VPC"
    builder                 = var.builder
    application_owner       = var.application_owner
    vpc                     = var.cell_name
    cell_name               = var.cell_name
    component_name          = format("%s-%s", var.component_name, terraform.workspace)
  }
}
