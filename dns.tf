data "aws_route53_zone" "zone" {
  zone_id = "${var.hosted_zone_id}"
}

# Primary domain DNS record
resource "aws_route53_record" "root" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.dist.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.dist.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${local.subdomain_fqdn}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.dist.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.dist.hosted_zone_id}"
    evaluate_target_health = false
  }
}
