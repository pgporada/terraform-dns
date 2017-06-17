# Overview: terraform-dns
Builds the following infrastructure in AWS

* Route53 private zone
* Route53 public zone

- - - -
# Usage
The Makefile will pull down a fresh secrets variable file from S3 during the **plan** and **apply** phases. This file does not exist by default.

    ENVIRONMENT=c6h12o6 make plan
    ENVIRONMENT=c6h12o6 make apply

- - - -
# Updating variables for an environment

    aws s3 --profile=c6h12o6 cp s3://some-bucket/terraform/dns/c6h12o6.tfvars .
    vim c6h12o6.tfvars
    aws s3 --profile=c6h12o6 cp c6h12o6.tfvars s3://some-bucket/terraform/dns/c6h12o6.tfvars

- - - -
# Theme Music
[Hermit Stew - Resilient Bones](https://www.youtube.com/watch?v=AyeiERr4pgw)
