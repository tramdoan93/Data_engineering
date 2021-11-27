from datetime import datetime
from airflow import DAG
from airflow.operators.email import EmailOperator
from airflow.operators.python import PythonOperator
from crawl_data_covid_location import run
from update_ftable_covid_location_daily import run_updatedb


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
}

with DAG(
        'Crawl_data_covid',
        default_args=default_args,
        description='Crawl data covid',
        schedule_interval='30 14 * * *',
        start_date=datetime(2021, 11, 18),
        catchup=False,
        tags=['Crawl_data_covid'],
) as dag:
    t1 = PythonOperator(task_id='Crawl_data_covid',
                        python_callable=run,
                        dag=dag,
                        )
    t2 = PythonOperator(
        task_id='save_data_into_dwh',
        python_callable=run_updatedb
    )

    t1 >> t2