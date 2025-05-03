variable "aws_region" {
  default = "us-east-2"
}

variable "aws_profile" {
  description = "AWS CLI profile name to use for authentication"
}

variable "bucket_name" {
  description = "S3 bucket name to use for backend"
}

variable terraform_lock_dbname {

}

variable terraform_backend_s3_bucket {

}

variable project_name {
  description = "Project name"
}