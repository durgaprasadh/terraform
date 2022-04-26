# Configure the Terraform AWS Provider
provider "aws" {
  region  = "eu-west-1"
  version = "~> 3.0"
  access_key = "AKIASZET6KL54KTGGRZS"
  secret_key = "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"
}
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
