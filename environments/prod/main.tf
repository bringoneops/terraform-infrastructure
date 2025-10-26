terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "Terraform"
      Project     = "terraform-infrastructure"
    }
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# Example resource - replace with your actual infrastructure
resource "aws_s3_bucket" "example" {
  bucket = "example-prod-bucket-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name           = "Production Example Bucket"
    TestPipeline   = "prod-test"
    Environment    = "production"
  }
}

data "aws_caller_identity" "current" {}

output "bucket_name" {
  description = "Name of the example S3 bucket"
  value       = aws_s3_bucket.example.id
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}
