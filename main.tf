variable "region" {}
variable "access" {}
variable "secret" {}
variable "env" {}
variable "account_id" {}
variable "domain_public" {}
variable "domain_private" {}
variable "kms_key_id" {}
variable "account_id" {}

terraform {
  required_version = ">= 0.9.8"
  backend "s3" {
    encrypt    = true
    acl        = "private"
  }
}

provider "aws" {
  region              = "${var.region}"
  profile             = "${var.env}"
  allowed_account_ids = ["${var.account_id}"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    region     = "${var.region}"
    bucket     = "${var.state_bucket}"
    key        = "terraform/vpc/${var.env}.tfstate"
    profile    = "${var.env}"
    encrypt    = 1
    acl        = "private"
    kms_key_id = "arn:aws:kms:${var.region}:${var.account_id}:key/${var.kms_key_id}"
  }
}

module "public_dns" {
  source  = "modules/public_zone"
  region  = "${var.region}"
  domain  = "${var.domain_public}"
}

module "private_dns" {
  source = "modules/private_zone"
  region = "${var.region}"
  env    = "${var.env}"
  domain = "${var.domain_private}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

output "public_domain" {
  value = "${module.public_dns.domain}"
}

output "public_zone_id" {
  value = "${module.public_dns.zone_id}"
}

output "private_domain" {
  value = "${module.private_dns.domain}"
}

output "private_zone_id" {
  value = "${module.private_dns.zone_id}"
}
