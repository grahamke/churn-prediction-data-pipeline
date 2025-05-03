##############################
# Athena Workgroup
##############################

resource "aws_athena_workgroup" "churn_queries" {
  name = "churn-analytics"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.churn_data.bucket}/athena-results/"
    }
  }

  state = "ENABLED"
}