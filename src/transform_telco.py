import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from awsglue.dynamicframe import DynamicFrame

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
logger = glueContext.get_logger()

# Parameters (if passed)
args = getResolvedOptions(sys.argv, ["output_path"])
output_path = args["output_path"]

# Step 1: Read from Glue Data Catalog
dyf_raw = glueContext.create_dynamic_frame.from_catalog(
    database="churn_data",
    table_name="raw_telco"
)

logger.info("Raw record count: {}".format(dyf_raw.count()))

# Step 2: Convert to DataFrame for transformation
df = dyf_raw.toDF()

# Step 3: Clean and transform fields
from pyspark.sql.functions import col, trim, when

df_cleaned = (
    df
    .withColumn(
        "total_charges",
        when(col("TotalCharges.string").isNotNull(), col("TotalCharges.string").cast("double"))
        .when(col("TotalCharges.double").isNotNull(), col("TotalCharges.double"))
        .when(col("TotalCharges").cast("double").isNotNull(), col("TotalCharges").cast("double"))
        .otherwise(None)
    )
    .withColumn("is_senior", col("SeniorCitizen").cast("boolean"))
    .withColumn("did_churn", when(trim(col("Churn")) == "Yes", True).otherwise(False))
    .drop("TotalCharges", "SeniorCitizen", "Churn")
)

# Step 4: Convert back to DynamicFrame
dyf_cleaned = DynamicFrame.fromDF(df_cleaned, glueContext, "dyf_cleaned")

# Step 5: Write to curated zone in Parquet
glueContext.write_dynamic_frame.from_options(
    frame=dyf_cleaned,
    connection_type="s3",
    connection_options={"path": output_path},
    format="parquet"
)

logger.info("Transformation complete. Output written to: {}".format(output_path))
