-- Drop table

-- DROP TABLE dwh.f_covid_location_daily;

CREATE TABLE dwh.f_covid_location_daily (
	date_id int4 NOT NULL,
	province_id bpchar(2) NOT NULL,
	new_infected_cases int4 NULL,
	deaths_case int4 NULL,
	created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	update_at timestamp NULL,
	CONSTRAINT f_covid_location_daily_pkey PRIMARY KEY (date_id, province_id)
);
