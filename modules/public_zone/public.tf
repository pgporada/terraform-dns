variable "region" {}
variable "domain" {}

resource "aws_route53_zone" "zone" {
  name       = "${var.domain}"
  vpc_region = "${var.region}"

  tags {
    TERRAFORM = "true"
  }
}

output "domain" {
  value = "${aws_route53_zone.zone.name}"
}

output "zone_id" {
  value = "${aws_route53_zone.zone.zone_id}"
}
