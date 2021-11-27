-- Drop table if exists
DROP TABLE if exists d_date;

-- Create dim table d_date
CREATE TABLE master.d_date
(
  date_id              INT NOT NULL,
  date_              DATE NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  month_           INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_              INT NOT NULL,
  first_day_of_week        DATE NOT NULL,
  last_day_of_week         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
  last_day_of_year         DATE NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  weekend_indr             BOOLEAN NOT NULL
);
-- Add primary key for table
ALTER TABLE master.d_date ADD CONSTRAINT d_date_date_dim_id_pk PRIMARY KEY (date_id);
-- Add index for d_date
CREATE INDEX d_date_idx
  ON master.d_date(date_);

-- Insert data into table 
 INSERT INTO master.d_date
	SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
       datum AS date_,
       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_name,
       EXTRACT(ISODOW FROM datum) AS day_of_week,
       EXTRACT(DAY FROM datum) AS day_of_month,
       datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(MONTH FROM datum) AS month_,
       TO_CHAR(datum, 'TMMonth') AS month_name,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'Q1'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Q2'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Q3'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Q4'
           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year_,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE
           ELSE FALSE
           END AS weekend_indr
	FROM (SELECT '2020-01-01'::DATE + SEQUENCE.DAY AS datum
	      FROM GENERATE_SERIES(0, 2030) AS SEQUENCE (DAY)
	      GROUP BY SEQUENCE.DAY) DQ
	ORDER BY 1;

COMMIT;