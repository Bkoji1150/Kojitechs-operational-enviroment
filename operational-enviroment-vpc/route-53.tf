

data "aws_route53_zone" "mydomain" {
  name = lookup(var.dns_name, terraform.workspace)
}

data "aws_caller_identity" "current" {}
# DNS Registration
## Default DNS
resource "aws_route53_record" "default_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = lookup(var.dns_nam, terraform.workspace)
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"

  version = "3.0.0"

  domain_name = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  zone_id     = data.aws_route53_zone.mydomain.zone_id

  subject_alternative_names = tolist([lookup(var.subject_alternative_names, terraform.workspace)])

}
