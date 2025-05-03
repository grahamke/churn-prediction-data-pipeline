# 🧠 Churn Prediction Project (AWS DEA-C01 Exam Aligned)
This project implements a real-world customer churn prediction pipeline using AWS services covered on the AWS Certified Data Engineer – Associate (DEA-C01) exam. The goal is to reinforce practical, hands-on experience with each major exam domain using a simplified but realistic data lake architecture.

---
## 🎯 Project Goals
* Use only AWS services that appear on the DEA-C01 exam
* Create a practical, exam-aligned data pipeline from ingestion to transformation
* Demonstrate core data engineering concepts including metadata management, data transformation, governance, and performance optimization

S3 (Raw Zone) --> Glue Crawler --> Glue Data Catalog --> Athena/Glue Jobs
\                                                  |
--> IAM + Workgroup Config --> S3 (Curated Zone) |

---
## 📚 Step-by-Step Project Workflow
### ✅ Step 1: Data Ingestion and Metadata Discovery
DEA-C01 Domains: 1, 4
* Upload telco_churn.csv to s3://kg-churn-prediction-data/raw/telco/
* Create S3 bucket with versioning + encryption
* Run AWS Glue Crawler to scan and register metadata in Glue Data Catalog

Tools Covered:
S3, Glue Crawler, Glue Data Catalog, IAM

---
### ✅ Step 2: Data Exploration with Athena
DEA-C01 Domain: 2

* Configure Athena Workgroup churn-analytics
* Set centralized output location in S3 (/athena-results/)
* Use Athena to:
  * Preview data
  * Identify type issues (e.g., TotalCharges as string)
  * Validate ingestion

Tools Covered:
Athena, Workgroups, Glue Catalog, S3 Output Location

---
### ✅ Step 3: Data Transformation with Glue Job
DEA-C01 Domains: 1, 2, 3

* Create a Glue Job using PySpark
* Read data from raw_telco
* Clean/transform:
  * Cast TotalCharges to double
  * Convert Churn to boolean
* Write to s3://kg-churn-prediction-data/curated/telco/ in Parquet

Tools Covered:
AWS Glue Job, S3, Job Bookmarks, IAM, CloudWatch Logs

---
### ✅ Step 4: Query Optimization and Data Validation
DEA-C01 Domain: 2

* Query transformed Parquet data using Athena
* Compare performance vs raw CSV
* Review partitioning options and Parquet structure

Tools Covered:
Athena, Parquet, Partitioning, Glue Catalog

---
### ✅ Step 5: Security and Governance
DEA-C01 Domain: 4

* Apply IAM roles with least-privilege access for Glue and Athena
* Enable server-side encryption on S3
* (Optional) Use Lake Formation to apply table-level access policies

Tools Covered:
IAM, S3 Encryption, Lake Formation (optional)

---
## 📦 Tools and Services Practiced
|Service|Category|
|-------|--------|
|Amazon S3|Data lake storage|
|AWS Glue Crawler|Schema discovery|
|AWS Glue Data Catalog|Metadata management|
|AWS Glue Jobs|Data transformation|
|Amazon Athena|Query engine|
|IAM|Access control|
|CloudWatch Logs|Job monitoring|
|Lake Formation|(Optional) fine-grained governance|

---
## 🧪 Dataset Used
Telco Customer Churn Dataset
Source: [Kaggle](https://www.kaggle.com/blastchar/telco-customer-churn)
Static CSV snapshot used for schema inference and transformation exercises.

---
## 🧠 Certification Benefit
| DEA-C01 Domain | Reinforced By                                  |
|----------------|------------------------------------------------|
| Domain 1: Ingestion & Transformation | Glue Jobs, S3, PySpark, Glue Crawlers |
| Domain 2: Data Store Management      | Glue Catalog, Parquet, Partitioning   |
| Domain 3: Data Operations            | Job orchestration, query optimization |
| Domain 4: Security & Governance      | IAM, S3 policies, encryption, workgroup enforcement |

---
## 🚧 Next Steps
* Add Terraform module to provision all infrastructure
* Deploy Glue Job with PySpark transformation logic
* Add CI/CD trigger to automate ETL
* Simulate future data ingestion to practice incremental ETL with bookmarks
