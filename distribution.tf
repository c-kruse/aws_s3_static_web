locals {
  origin_id = "S3-${data.aws_route53_zone.zone.name}"
}

resource "aws_cloudfront_origin_access_identity" "identity" {
  comment = "S3 Access Identity for ${data.aws_route53_zone.zone.name} and ${local.subdomain_fqdn}"
}

resource "aws_cloudfront_distribution" "dist" {
  aliases = [
    "${local.root_fqdn}",
    "${local.subdomain_fqdn}",
  ]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    target_origin_id       = "${local.origin_id}"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "${var.index_document}"
  price_class         = "${var.distribution_price_class}"

  origin {
    domain_name = "${aws_s3_bucket.website.bucket_regional_domain_name}"
    origin_id   = "${local.origin_id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.identity.cloudfront_access_identity_path}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  tags {
    Terraform = 1
    Scope     = "${data.aws_route53_zone.zone.name}"
  }
}
