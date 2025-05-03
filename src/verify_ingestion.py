import boto3
import time
import pandas as pd
import argparse

def create_athena_client(profile_name):
    session = boto3.Session(profile_name=profile_name)
    return session.client("athena")

def run_query(query, athena, database, output, workgroup):
    response = athena.start_query_execution(
        QueryString=query,
        QueryExecutionContext={"Database": database},
        ResultConfiguration={"OutputLocation": output},
        WorkGroup=workgroup
    )
    return response["QueryExecutionId"]

def wait_for_query(execution_id, athena):
    while True:
        result = athena.get_query_execution(QueryExecutionId=execution_id)
        state = result["QueryExecution"]["Status"]["State"]
        if state in ["SUCCEEDED", "FAILED", "CANCELLED"]:
            return state
        time.sleep(1)

def get_results(execution_id, athena):
    paginator = athena.get_paginator('get_query_results')
    results_iter = paginator.paginate(QueryExecutionId=execution_id)

    rows = []
    header = []
    for i, page in enumerate(results_iter):
        for row_index, row in enumerate(page["ResultSet"]["Rows"]):
            values = [col.get("VarCharValue","") for col in row["Data"]]
            if i == 0 and row_index == 0:
                header = values
            else:
                rows.append(values)
    return pd.DataFrame(rows, columns=header)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run Athena query to verify data ingestion.")
    parser.add_argument("--profile", required=True, help="AWS CLI profile name")
    args = parser.parse_args()

    athena = create_athena_client(args.profile)
    database = "churn_data"
    output = "s3://kg-churn-prediction-data/athena-results/"
    workgroup = "churn-analytics"
    query = "SELECT * FROM raw_telco LIMIT 10"

    qid = run_query(query, athena, database, output, workgroup)
    print(f"Query ID: {qid}")
    status = wait_for_query(qid, athena)
    print(f"Query Status: {status}")
    if status == "SUCCEEDED":
        df = get_results(qid, athena)
        print(df.head)
    else:
        print("Query Failed")