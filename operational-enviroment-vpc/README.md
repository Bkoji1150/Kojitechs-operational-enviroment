#### AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM
AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM

This module was built VPC IN ACCOUN-A AND BUILD S3 BUCKET IN ACCOUN-B [cookiecutter-microservice](https://github.com/Bkoji1150/AWS-S3-CROSS-ACCOUNT-ACCESS-WITH-TERRAFORM).

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
| <a name="module_private_instance"></a> [private\_instance](#module\_private\_instance) | terraform-aws-modules/ec2-instance/aws | n/a |
| <a name="module_required_tags"></a> [required\_tags](#module\_required\_tags) | git::git@github.com:Bkoji1150/kojitechs-tf-aws-required-tags.git | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ec2profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2_ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.default_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.lambda_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_lambda_bucketaccount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_security_group.app_sg1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.app_sg3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.web_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [null_resource.name](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_access_lambda_bucket_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.mydomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret_version.rds_secret_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_ssm_parameter.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.mysql_aurura_secrets](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ado"></a> [ado](#input\_ado) | Compainy name for this project | `string` | `"Kojitechs"` | no |
| <a name="input_app_port"></a> [app\_port](#input\_app\_port) | n/a | `string` | `"3306"` | no |
| <a name="input_application_owner"></a> [application\_owner](#input\_application\_owner) | Email Group for the Application owner. | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | Environment this template would be deployed to | `map(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_builder"></a> [builder](#input\_builder) | Email for the builder of this infrastructure | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_cell_name"></a> [cell\_name](#input\_cell\_name) | Name of the ECS cluster to deploy the service into. | `string` | `"APP"` | no |
| <a name="input_component_name"></a> [component\_name](#input\_component\_name) | Name of the component. | `string` | `"hqr-common-vpc"` | no |
| <a name="input_db_subnets_cidr"></a> [db\_subnets\_cidr](#input\_db\_subnets\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_dns_nam"></a> [dns\_nam](#input\_dns\_nam) | n/a | `map(string)` | <pre>{<br>  "prod": "kojitechs.com",<br>  "sbx": "www.kelderanyi.com"<br>}</pre> | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | n/a | `map(string)` | <pre>{<br>  "prod": "kojitechs.com",<br>  "sbx": "kelderanyi.com"<br>}</pre> | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Specifies the major version of the engine that this option group should be associated with | `string` | `"13.4"` | no |
| <a name="input_lambda_buckets"></a> [lambda\_buckets](#input\_lambda\_buckets) | n/a | `list` | <pre>[<br>  "lambda.bucket.secrets.rotation"<br>]</pre> | no |
| <a name="input_line_of_business"></a> [line\_of\_business](#input\_line\_of\_business) | Line of Business | `string` | `"Kojitechs"` | no |
| <a name="input_myipp"></a> [myipp](#input\_myipp) | n/a | `string` | `"71.163.242.34/32"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `list(any)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `list(any)` | n/a | yes |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | n/a | `map(string)` | <pre>{<br>  "prod": "*.kojitechs.com",<br>  "sbx": "*.kelderanyi.com"<br>}</pre> | no |
| <a name="input_tech_poc_primary"></a> [tech\_poc\_primary](#input\_tech\_poc\_primary) | Primary Point of Contact for Technical support for this service. | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_tech_poc_secondary"></a> [tech\_poc\_secondary](#input\_tech\_poc\_secondary) | Secondary Point of Contact for Technical support for this service. | `string` | `"kojibello058@gmail.com"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Canonical name of the application tier | `string` | `"APP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones spefified as argument to this module |
| <a name="output_baston_id"></a> [baston\_id](#output\_baston\_id) | n/a |
| <a name="output_database_cidr"></a> [database\_cidr](#output\_database\_cidr) | n/a |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_db_subnet_ids"></a> [db\_subnet\_ids](#output\_db\_subnet\_ids) | n/a |
| <a name="output_db_subnets_names"></a> [db\_subnets\_names](#output\_db\_subnets\_names) | n/a |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | n/a |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#output\_private\_subnets\_cidrs) | n/a |
| <a name="output_public_subnet_cidr_block"></a> [public\_subnet\_cidr\_block](#output\_public\_subnet\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_rout_table"></a> [rout\_table](#output\_rout\_table) | n/a |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | List of IDs of route table id |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Authors

## Usage 
ec2 instance private keypair in stored in ssm parameter store to download the key form ssm parameter store 

```bash
aws ssm get-parameter --name "jenkins-agent-bootstrap-ssh-key" --output text --query Parameter.Value >> "./jenkins_ssh_file"
ssh -i "jenkins_ssh_file" ec2-user@public_ip
```

Module is maintained by [&&&](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/graphs/contributors).
