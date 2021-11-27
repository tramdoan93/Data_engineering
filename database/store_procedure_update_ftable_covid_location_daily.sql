CREATE OR REPLACE PROCEDURE dwh.update_ftable_covid_location_daily(v_date date)
 LANGUAGE plpgsql
AS $procedure$

begin
with covid_location as (
select 
	stat_date,
	case 
		when province ='TP HCM' then 'Hồ Chí Minh' 
		else province 
	end province,
	new_infected_cases,
	deaths_case
from raw.covid_locations 
where stat_date >= v_date
),
final_data as (
select 
	d.date_id,
	p.province_id,
	a.new_infected_cases,
	a.deaths_case
from covid_location a 
inner join master.d_province p 
   on a.province = p.province_name 
inner join master.d_date d 
   on a.stat_date = d.date_ 
 )
INSERT INTO dwh.f_covid_location_daily (date_id, province_id,new_infected_cases, deaths_case)
select * from final_data
ON CONFLICT (date_id,province_id) DO UPDATE 
  SET new_infected_cases = excluded.new_infected_cases, 
      deaths_case = excluded.deaths_case,
      update_at = excluded.update_at ;
end; $procedure$
;
