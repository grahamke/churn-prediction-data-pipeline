variable "aws_region" {
  default = "us-east-2"
}

variable "aws_profile" {
  description = "AWS CLI profile name to use for authentication"
}

variable "bucket_name" {
  description = "S3 bucket name to use for backend"
}

variable project_name {
  description = "Project name"
  default = "churn"
}