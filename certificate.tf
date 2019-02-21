resource "aws_acm_certificate" "cert" {
  domain_name               = "${data.aws_route53_zone.zone.name}"
  subject_alternative_names = ["${local.subdomain_fqdn}"]
  validation_method         = "DNS"

  tags {
    Terrafmrom = 1
    Scope      = "${data.aws_route53_zone.zone.name}"
    Name       = "${data.aws_route53_zone.zone.name}"
  }
}

resource "aws_route53_record" "root_validation" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
}

resource "aws_route53_record" "subdomain_validation" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.root_validation.fqdn}",
    "${aws_route53_record.subdomain_validation.fqdn}",
  ]
}
