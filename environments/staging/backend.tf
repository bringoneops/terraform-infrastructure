terraform {
  backend "s3" {
    bucket         = "terraform-state-staging-008151864528-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-staging"
    encrypt        = true
  }
}
