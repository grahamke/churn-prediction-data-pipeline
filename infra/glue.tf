################################
# Glue Data Catalog + Crawler
################################

resource aws_glue_catalog_database churn_db {
  name = "churn_data"
}

resource "aws_iam_role" "glue_crawler_role" {
  name = "glue_crawler_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "glue_crawler_policy" {
  name = "glue_crawler_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.churn_data.arn,
          "${aws_s3_bucket.churn_data.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = "glue:*"
        Resource = "*"
      }
    ]
  })
}

resource aws_iam_role_policy_attachment "glue_attached" {
  role = aws_iam_role.glue_crawler_role.name
  policy_arn = aws_iam_policy.glue_crawler_policy.arn
}

resource aws_glue_crawler churn_crawler {
  name = "churn-csv-crawler"
  role = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.churn_db.name
  schedule = null
  table_prefix = "raw_"

  s3_target {
    path = "s3://${aws_s3_bucket.churn_data.bucket}/raw/telco"
  }

  configuration = jsonencode({
    Version = 1.0,
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })
}

##############################
# Glue Job
##############################

resource "aws_iam_role" "glue_job_role" {
  name = "glue-job-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "glue.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "glue_job_policy" {
  name = "glue-job-policy"
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: ["s3:*"],
        Resource: [
          aws_s3_bucket.churn_data.arn,
          "${aws_s3_bucket.churn_data.arn}/*"
        ]
      },
      {
        Effect: "Allow",
        Action: ["glue:*"],
        Resource: ["*"]
      },
      {
        Effect: "Allow",
        Action: ["logs:*"],
        Resource: ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_job_attach" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = aws_iam_policy.glue_job_policy.arn
}

resource "aws_glue_job" "transform_telco" {
  name              = "transform-telco"
  role_arn          = aws_iam_role.glue_job_role.arn
  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.churn_data.bucket}/scripts/transform_telco.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-bookmark-option" = "job-bookmark-disable"
    "--TempDir"             = "s3://${aws_s3_bucket.churn_data.bucket}/temp/"
    "--output_path"         = "s3://${aws_s3_bucket.churn_data.bucket}/curated/partitioned_glue"
  }

  execution_class = "STANDARD"
  max_retries     = 0
  timeout         = 10
}