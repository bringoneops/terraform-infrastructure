terraform {
  backend "s3" {
    bucket         = "terraform-state-dev-008151864528-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks-dev"
    encrypt        = true
  }
}
