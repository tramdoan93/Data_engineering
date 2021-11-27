import psycopg2
import config
import datetime

# get yesterday value
yesterday = datetime.datetime.now() - datetime.timedelta(days=2)
yesterday = str(yesterday.strftime("%Y-%m-%d"))
print(yesterday)

# connect to postgre database
conn_dwh = psycopg2.connect(user=config.PSQL_USER,
                            password=config.PSQL_PASSWORD,
                            host=config.PSQL_HOST,
                            port=config.PSQL_PORT,
                            database=config.PSQL_DB)


# Insert DataFrame records one by one.
def update_data():
    cursor = conn_dwh.cursor()
    sql = "call dwh.update_ftable_covid_location_daily('" + str(yesterday) + "');"
    # cursor.execute("call dwh.update_ftable_covid_location_historical()")
    cursor.execute(sql)
    conn_dwh.commit()
    conn_dwh.close()


def run_updatedb():
    update_data()


if __name__ == '__main__':
    run_updatedb()
