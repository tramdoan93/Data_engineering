import os

TOMTOM_API = os.getenv("TOMTOM_API", "https://api.midway.tomtom.com/ranking/liveHourly/IDN_jakarta")
CSV_FILE_DIR = os.getenv("CSV_FILE_DIR", "/opt/airflow/dags/datasets/tomtom")

PSQL_AIRFLOW_DB = os.getenv("PSQL_DB", "airflow_db")
PSQL_DB = os.getenv("PSQL_DB", "airflow_db")
PSQL_USER = os.getenv("PSQL_USER", "airflow_user") 
PSQL_PASSWORD = os.getenv("PSQL_PASSWORD", "airflow_pass")
PSQL_PORT = os.getenv("PSQL_PORT", "5432")
PSQL_HOST = os.getenv("PSQL_HOST", "localhost")