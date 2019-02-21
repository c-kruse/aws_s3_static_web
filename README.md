# AWS Static Website Module

This repo contains a [terraform](https://www.terraform.io/docs/modules/index.html) module for deploying a static website.

## Resources

`aws_acm_certificate` 
`aws_cloudfront_distribution`
`aws_route53_record`
`aws_s3_bucket`


## Usage

* Set up your aws provider in terraform in `us-east-1`. This is important because CloudFront requires the ACM certificats it uses to be created in `us-east-1`.
* Provision (manually or though terraform) the aws_route53_zone where the website will live.
* Add the aws_s3_static_web module and deploy (may take a second try due to acm certificate verification lag).

Example Usage:
```
provider "aws" {
  region = "us-east-1"
  version = "~> 1.40"
...
}
resource "aws_route53_zone" "ctkruse" {
  name = "ctkruse.com"
}

module "ctkruse" {
  source         = "github.com/c-kruse/aws_s3_static_web"
  // Required Arguments
  hosted_zone_id = "${aws_route53_zone.ctkruse.zone_id}"
  // Optional Arguments
  subdomain  = "*"
  index_document = "myindex.html"
  error_document = "ohno.html"
  distribution_price_class = "PriceClass_200"
}

```
