variable "region" {}
variable "env" {}
variable "vpc_id" {}
variable "domain" {}

resource "aws_vpc_dhcp_options" "dns_resolvers" {
  domain_name         = "${var.domain}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name      = "${var.env}-route-table"
    TERRAFORM = "true"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${var.vpc_id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolvers.id}"
}

resource "aws_route53_zone" "zone" {
  name       = "${var.domain}"
  vpc_region = "${var.region}"
  vpc_id     = "${var.vpc_id}"

  tags {
    Name      = "${var.env}-private-r53-zone"
    TERRAFORM = "true"
  }
}

output "domain" {
  value = "${aws_route53_zone.zone.name}"
}

output "zone_id" {
  value = "${aws_route53_zone.zone.zone_id}"
}
