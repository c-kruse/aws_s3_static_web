resource "aws_s3_bucket" "website" {
  bucket = "${local.root_fqdn}"

  website = {
    index_document = "${var.index_document}"
    error_document = "${var.error_document}"
  }

  tags = {
    Terraform = 1
    Scope     = "${data.aws_route53_zone.zone.name}"
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = "${aws_s3_bucket.website.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PrimaryCloudFrontGetObject",
      "Effect": "Allow",
      "Principal": {"AWS": ["${aws_cloudfront_origin_access_identity.identity.iam_arn}"]},
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.website.arn}/*"
    },
    {
      "Sid": "PrimaryCloudFrontListBucket",
      "Effect": "Allow",
      "Principal": {"AWS": ["${aws_cloudfront_origin_access_identity.identity.iam_arn}"]},
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.website.arn}"
    }
  ]
}
POLICY
}
