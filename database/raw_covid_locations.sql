-- Drop table

-- DROP TABLE raw.covid_locations;

CREATE TABLE raw.covid_locations (
	stat_date date NOT NULL,
	province varchar(50) NOT NULL,
	new_infected_cases int4 NULL,
	deaths_case int4 NULL,
	created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT covid_locations_pkey PRIMARY KEY (stat_date, province)
);
