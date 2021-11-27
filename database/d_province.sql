-- Drop table

-- DROP TABLE master.d_province;

CREATE TABLE master.d_province (
	province_id bpchar(2) NOT NULL,
	province_name varchar(200) NULL,
	level_ varchar(50) NULL,
	region_level1 varchar(100) NULL,
	region_level2 varchar(100) NULL,
	created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	update_at timestamp NULL,
	CONSTRAINT d_province_pkey PRIMARY KEY (province_id)
);
