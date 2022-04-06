## operational-enviroment-vpc

This module was built ec2 IN operational-enviroment-vpc[cookiecutter-microservice](https://github.com/Bkoji1150/AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM).

<!-- prettier-ignore-start -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.5 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 3.0.0 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | 6.0.0 |
| <a name="module_ec2_instance_pub"></a> [ec2\_instance\_pub](#module\_ec2\_instance\_pub) | terraform-aws-modules/ec2-instance/aws | n/a |
| <a name="module_mysql_aurora"></a> [mysql\_aurora](#module\_mysql\_aurora) | terraform-aws-modules/rds/aws | 3.0.0 |
| <a name="module_private_instance"></a> [private\_instance](#module\_private\_instance) | terraform-aws-modules/ec2-instance/aws | n/a |
| <a name="module_required_tags"></a> [required\_tags](#module\_required\_tags) | git::https://github.com/Bkoji1150/kojitechs-tf-aws-required-tags.git | n/a |
| <a name="module_sprint_instance"></a> [sprint\_instance](#module\_sprint\_instance) | terraform-aws-modules/ec2-instance/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.default_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.app_sg1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [null_resource.name](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.mydomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.operational_environment](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ado"></a> [ado](#input\_ado) | Compainy name for this project | `string` | `"Kojitechs"` | no |
| <a name="input_application_owner"></a> [application\_owner](#input\_application\_owner) | Email Group for the Application owner. | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | Environment this template would be deployed to | `map(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_builder"></a> [builder](#input\_builder) | Email for the builder of this infrastructure | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_cell_name"></a> [cell\_name](#input\_cell\_name) | Name of the ECS cluster to deploy the service into. | `string` | `"APP"` | no |
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | Name of the component. | `string` | `"hqr-common-vpc"` | no |
| <a name="input_db_instance_identifier"></a> [db\_instance\_identifier](#input\_db\_instance\_identifier) | AWS RDS Database Instance Identifier | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | AWS RDS Database Name | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | AWS RDS Database Administrator Password | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | AWS RDS Database Administrator Username | `string` | n/a | yes |
| <a name="input_dns_nam"></a> [dns\_nam](#input\_dns\_nam) | n/a | `string` | n/a | yes |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | n/a | `map(string)` | <pre>{<br>  "prod": "kojitechs.com",<br>  "sbx": "www.kelderanyi.com"<br>}</pre> | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Specifies the major version of the engine that this option group should be associated with | `string` | `"13.4"` | no |
| <a name="input_line_of_business"></a> [line\_of\_business](#input\_line\_of\_business) | Line of Business | `string` | `"Kojitechs"` | no |
| <a name="input_myipp"></a> [myipp](#input\_myipp) | n/a | `string` | `"71.163.242.34/32"` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | n/a | `map(string)` | <pre>{<br>  "prod": "*.kojitechs.com",<br>  "sbx": "*.kelderanyi.com"<br>}</pre> | no |
| <a name="input_tech_poc_primary"></a> [tech\_poc\_primary](#input\_tech\_poc\_primary) | Primary Point of Contact for Technical support for this service. | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_tech_poc_secondary"></a> [tech\_poc\_secondary](#input\_tech\_poc\_secondary) | Secondary Point of Contact for Technical support for this service. | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Canonical name of the application tier | `string` | `"APP"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Authors

## Usage 
ec2 instance private keypair in stored in ssm parameter store to download the key form ssm parameter store 

```bash

```

Module is maintained by [&&&](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/graphs/contributors)
