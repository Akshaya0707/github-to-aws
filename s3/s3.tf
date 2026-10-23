
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "state" {
  bucket = "statefile23102026"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform-State"
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.state.bucket
}
