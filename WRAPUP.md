# Churn Prediction Data Pipeline Wrap-Up

This document summarizes the AWS-based data pipeline built for a customer churn prediction project, designed to reinforce hands-on experience with the tools and concepts required for the AWS Certified Data Engineer – Associate (DEA-C01) exam.

---
## 🎯 Project Purpose

To simulate a real-world customer churn data pipeline that:
* Ingests raw CSV data to S3
* Catalogs the schema with AWS Glue
* Transforms and cleans the data using Glue Jobs
* Outputs analytics-ready Parquet files
* Registers and queries the data using Amazon Athena
* Demonstrates partitioning, data governance, and query optimization
---
## 🧱 Architecture Overview

Services Used:
* Amazon S3
* AWS Glue Crawler
* AWS Glue Data Catalog
* AWS Glue Job (PySpark)
* Amazon Athena

Data Zones:
* raw/ — source CSV files
* curated/partitioned_glue/ — cleaned, partitioned Parquet files

Glue Catalog Tables:
* churn_data.raw_telco
* churn_data.cleaned_partitioned_glue
---
## 🧪 Project Steps and DEA-C01 Mapping
|Step| Description                                        | DEA-C01 Domains     |
|----|----------------------------------------------------|---------------------|
|1| Uploaded raw CSV to S3                             | Data Ingestion      |
|2| Ran Glue Crawler to catalog schema                 | Metadata Management |
|3| Queried raw data in Athena|Data Store Management|
|4| Built PySpark Glue Job to clean and normalize data | Data Transformation |
|5|Wrote partitioned Parquet data to curated zone|Data Optimization|
|6|Created external Athena table and ran MSCK REPAIR|Catalog Management|
|7|Queried partitioned table in Athena|Query Optimization|
---
## 🧠 Key Concepts Demonstrated
* Schema-on-read via Athena and Glue Catalog
* Partitioned data layout for cost-effective querying
* Columnar formats (Parquet) for performance
* ETL with Glue Job using PySpark and DynamicFrames
* Metadata management via Glue Crawler and Catalog
* Manual and automatic partition registration
* Centralized workgroup enforcement in Athena
* Governance and reproducibility using parameterized Glue scripts

---
## ✅ Remaining Opportunities

Optional next steps to extend the project:
* Enable Glue Job Bookmarks for incremental processing
* Apply encryption (S3 + KMS) and Lake Formation policies
* Export curated data to Redshift or SageMaker
* Visualize churn metrics using Amazon QuickSight
* Build CI/CD workflow with Terraform and GitHub Actions
---
## 📌 Final Notes

This project avoids the AWS Console wherever possible to reflect production-grade practices and emphasizes automation, reproducibility, and modular infrastructure.

It is suitable for portfolio demonstration and aligns tightly with hands-on skills tested in the __DEA-C01__ certification.