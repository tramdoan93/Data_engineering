import requests
import csv
import pandas as pd
import psycopg2
import config


# crawl data from website
def crawl_data(url):
    with requests.Session() as s:
        download = s.get(url)
        decoded_content = download.content.decode('utf-8')
        cr = csv.reader(decoded_content.splitlines(), delimiter=',')
        header = []
        header = next(cr)
        rows = []
        for row in cr:
            rows.append(row)
        df_ = pd.DataFrame(rows, columns=header)
        df_ = df_[df_['Ngày'] != '']
        df_ = df_.rename(columns={'Ngày': 'date_'})
        df_unpivoted = df_.melt(id_vars=['date_'], var_name='province', value_name='values')
        return df_unpivoted


# merge data into one data frame
def merge_data(df1, df2):
    df = pd.merge(df1, df2, on=('date_', 'province'), how='outer', indicator=True)
    df = df.rename(columns={'values_x': 'new_infected_cases', 'values_y': 'deaths_case'})
    df = df.drop(['_merge'], axis=1)
    df = df.fillna(0)

    df[['day','mth']] = df['date_'].str.split('/',expand=True,)
    df['year'] = 2021
    cols = ["year", "mth", "day"]
    df['stat_date'] = df[cols].apply(lambda x: '-'.join(x.values.astype(str)), axis="columns")
    df['stat_date'] = pd.to_datetime(df['stat_date'], format="%Y-%m-%d")
    df = df.drop(['mth','year','date_','day'], axis=1)
    df['new_infected_cases'] = df['new_infected_cases'].replace('','0')
    df['deaths_case'] = df['deaths_case'].replace('','0')
    return df

# connect to postgre database
conn_dwh = psycopg2.connect(user=config.PSQL_USER,
                            password=config.PSQL_PASSWORD,
                            host=config.PSQL_HOST,
                            port=config.PSQL_PORT,
                            database=config.PSQL_DB)

# # Insert DataFrame recrds one by one.
def insert_database(data):
    cursor = conn_dwh.cursor()
    for i, row in data.iterrows():
        sql = "INSERT INTO raw.covid_locations (stat_date, province, new_infected_cases,deaths_case) " \
              "VALUES (%s,%s,%s,%s)" \
              "ON CONFLICT (stat_date,province) DO UPDATE " \
              "SET " \
              "new_infected_cases = excluded.new_infected_cases, " \
              "deaths_case = excluded.deaths_case"
        cursor.execute(sql,(row.stat_date, row.province, row.new_infected_cases, row.deaths_case))
        conn_dwh.commit()
    conn_dwh.close()

def run():
    infected_url = 'https://vnexpress.net/microservice/sheet/type/covid19_2021_by_location'
    infected_case = crawl_data(url=infected_url)
    deaths_url = 'https://vnexpress.net/microservice/sheet/type/covid19_daily_deaths'
    deaths_case = crawl_data(url=deaths_url)
    data = merge_data(infected_case, deaths_case)
    # print(data)
    insert_database(data)

if __name__ == '__main__':
    run()