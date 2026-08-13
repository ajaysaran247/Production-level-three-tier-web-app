import json
import boto3
import pymysql

REGION = "us-east-1"
# Replace this with the exact secret name you found in the previous step!
SECRET_NAME = "three-tier-app/database-v2" 

def get_database_credentials():
    # Connect to AWS Secrets Manager
    client = boto3.client(
        "secretsmanager",
        region_name=REGION
    )

    # Fetch the secret
    response = client.get_secret_value(
        SecretId=SECRET_NAME
    )

    # Convert the JSON string into a Python dictionary
    secret = json.loads(response["SecretString"])
    return secret

def get_connection():
    # Get the credentials dynamically from AWS
    credentials = get_database_credentials()

    # Connect to MySQL using the fetched credentials
    connection = pymysql.connect(
        host=credentials["DB_HOST"],
        port=int(credentials["DB_PORT"]),
        user=credentials["DB_USER"],
        password=credentials["DB_PASSWORD"],
        database=credentials["DB_NAME"],
        cursorclass=pymysql.cursors.DictCursor
    )

    return connection
