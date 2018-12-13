resource aws_acm_certificate cert {
  provider = "aws.us_east_1"

  domain_name       = local.domain_name
  validation_method = "DNS"
  subject_alternative_names = local.aliases

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_route53_record cert_validation {
  count = length(local.all_names)

  name    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_type
  zone_id = var.zone.id
  records = [aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_value]
  ttl     = 60
}

resource aws_acm_certificate_validation cert {
  provider = "aws.us_east_1"

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
