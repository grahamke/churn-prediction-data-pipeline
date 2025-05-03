##############################
# S3 Buckets
##############################

resource aws_s3_bucket churn_data {
  bucket = var.bucket_name
  force_destroy = true
}

resource aws_s3_bucket_versioning versioning {
  bucket = aws_s3_bucket.churn_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource aws_s3_bucket_server_side_encryption_configuration encryption {
  bucket = aws_s3_bucket.churn_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}