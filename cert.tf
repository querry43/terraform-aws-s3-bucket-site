resource aws_acm_certificate cert {
  provider = aws.us_east_1

  domain_name               = local.domain_name
  validation_method         = "DNS"
  subject_alternative_names = local.aliases

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_route53_record cert_validation {
  provider = aws.us_east_1

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]

  zone_id = var.zone.id
  ttl     = 60
}

resource aws_acm_certificate_validation cert {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
