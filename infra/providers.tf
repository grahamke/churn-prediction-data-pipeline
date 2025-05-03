provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }

  backend "s3" {
    bucket         = "kevingraham-terraform-state"
    key            = "churn/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "kevingraham-terraform-locks"
    encrypt        = true
  }
}