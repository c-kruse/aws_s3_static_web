output "distribution_id" {
  value = "${aws_cloudfront_distribution.dist.id}"
}

output "certificate" {
  value = "${aws_acm_certificate.cert.arn}"
}

output "website" {
  value = "${aws_s3_bucket.website.id}"
}
