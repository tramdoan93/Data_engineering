-- Drop table

-- DROP TABLE master.d_district;

CREATE TABLE master.d_district (
	district_id bpchar(3) NOT NULL,
	district_name varchar(200) NULL,
	level_ varchar(50) NULL,
	province_id bpchar(2) NULL,
	created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	update_at timestamp NULL,
	CONSTRAINT d_district_pkey PRIMARY KEY (district_id),
	CONSTRAINT fk_province FOREIGN KEY (province_id) REFERENCES master.d_province(province_id)
);
