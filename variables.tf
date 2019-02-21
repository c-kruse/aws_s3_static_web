# Input variables
variable "hosted_zone_id" {
  type        = "string"
  description = "The aws_route53_zone zone_id this website will be hosted on."
}

variable "subdomain" {
  type        = "string"
  default     = "www"
  description = "Subdomain to redirect to priarmy domain"
}

variable "index_document" {
  type        = "string"
  default     = "index.html"
  description = "Index Document Path"
}

variable "error_document" {
  type        = "string"
  default     = "error.html"
  description = "Error Document Path"
}

variable "distribution_price_class" {
  type        = "string"
  default     = "PriceClass_100"
  description = "CloudFront Distribution Price Class"
}

# Derived
locals {
  "_search"        = "/[.]$/"
  "_replace"       = ""
  "root_fqdn"      = "${replace(data.aws_route53_zone.zone.name, local._search, local._replace)}"
  "subdomain_fqdn" = "${var.subdomain}.${local.root_fqdn}"
}
