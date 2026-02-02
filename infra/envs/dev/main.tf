terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-artifacts-${data.aws_caller_identity.current.account_id}"
}

resource "aws_dynamodb_table" "jobs" {
  name         = "${var.project_name}-jobs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "job_id"

  attribute {
    name = "job_id"
    type = "S"
  }
}

data "aws_caller_identity" "current" {}

variable "project_name" {
  type    = string
  default = "cicd-platform-mini-dev"
}

output "artifacts_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "jobs_table" {
  value = aws_dynamodb_table.jobs.name
}
