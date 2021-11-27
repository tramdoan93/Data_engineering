-- Drop table

-- DROP TABLE master.d_ward;

CREATE TABLE master.d_ward (
	ward_id bpchar(5) NOT NULL,
	ward_name varchar(200) NULL,
	level_ varchar(50) NULL,
	district_id bpchar(3) NULL,
	created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	update_at timestamp NULL,
	CONSTRAINT d_ward_pkey PRIMARY KEY (ward_id),
	CONSTRAINT fk_district FOREIGN KEY (district_id) REFERENCES master.d_district(district_id)
);
