#!/bin/bash

source ../default_profile

file=/glusterfs/users/erozier/data/Building_Permits.csv

psql -c "
	drop table if exists input.building_permits;

	create table input.building_permits (
	id integer not null, 
	permit_number varchar(9) not null, 
	permit_type varchar(30) not null, 
	issue_date date, 
	estimated_cost varchar(14), 
	amount_waived varchar(12) not null, 
	amount_paid varchar(10) not null, 
	total_fee varchar(12) not null, 
	street_number integer not null, 
	street_direction varchar(1) not null, 
	street_name varchar(20) not null, 
	suffix varchar(4), 
	work_description varchar(1000), 
	pin1 varchar(18), 
	pin2 varchar(18), 
	pin3 varchar(18), 
	pin4 varchar(18), 
	pin5 varchar(18), 
	pin6 varchar(18), 
	pin7 varchar(18), 
	pin8 varchar(18), 
	pin9 varchar(18), 
	pin10 varchar(18), 
	contractor_1_type varchar(30), 
	contractor_1_name varchar(69), 
	contractor_1_address varchar(60), 
	contractor_1_city varchar(27), 
	contractor_1_state varchar(14), 
	contractor_1_zipcode varchar(11), 
	contractor_1_phone varchar(19), 
	contractor_2_type varchar(30), 
	contractor_2_name varchar(72), 
	contractor_2_address varchar(60), 
	contractor_2_city varchar(27), 
	contractor_2_state varchar(17), 
	contractor_2_zipcode varchar(12), 
	contractor_2_phone varchar(19), 
	contractor_3_type varchar(30), 
	contractor_3_name varchar(75), 
	contractor_3_address varchar(60), 
	contractor_3_city varchar(29), 
	contractor_3_state varchar(15), 
	contractor_3_zipcode varchar(12), 
	contractor_3_phone varchar(19), 
	contractor_4_type varchar(30), 
	contractor_4_name varchar(71), 
	contractor_4_address varchar(60), 
	contractor_4_city varchar(18), 
	contractor_4_state varchar(19), 
	contractor_4_zipcode varchar(10), 
	contractor_4_phone varchar(20), 
	contractor_5_type varchar(30), 
	contractor_5_name varchar(77), 
	contractor_5_address varchar(59), 
	contractor_5_city varchar(20), 
	contractor_5_state varchar(12), 
	contractor_5_zipcode varchar(10), 
	contractor_5_phone varchar(19), 
	contractor_6_type varchar(30), 
	contractor_6_name varchar(80), 
	contractor_6_address varchar(56), 
	contractor_6_city varchar(20), 
	contractor_6_state varchar(8), 
	contractor_6_zipcode varchar(10), 
	contractor_6_phone varchar(19), 
	contractor_7_type varchar(30), 
	contractor_7_name varchar(70), 
	contractor_7_address varchar(57), 
	contractor_7_city varchar(26), 
	contractor_7_state varchar(10), 
	contractor_7_zipcode varchar(10), 
	contractor_7_phone varchar(19), 
	contractor_8_type varchar(27), 
	contractor_8_name varchar(71), 
	contractor_8_address varchar(60), 
	contractor_8_city varchar(18), 
	contractor_8_state varchar(16), 
	contractor_8_zipcode varchar(10), 
	contractor_8_phone varchar(15), 
	contractor_9_type varchar(27), 
	contractor_9_name varchar(80), 
	contractor_9_address varchar(58), 
	contractor_9_city varchar(18), 
	contractor_9_state varchar(8), 
	contractor_9_zipcode varchar(10), 
	contractor_9_phone varchar(15), 
	contractor_10_type varchar(27), 
	contractor_10_name varchar(55), 
	contractor_10_address varchar(57), 
	contractor_10_city varchar(18), 
	contractor_10_state varchar(10), 
	contractor_10_zipcode varchar(12), 
	contractor_10_phone varchar(15), 
	contractor_11_type varchar(27), 
	contractor_11_name varchar(45), 
	contractor_11_address varchar(44), 
	contractor_11_city varchar(17), 
	contractor_11_state varchar(8), 
	contractor_11_zipcode varchar(10), 
	contractor_11_phone varchar(15), 
	contractor_12_type varchar(27), 
	contractor_12_name varchar(44), 
	contractor_12_address varchar(41), 
	contractor_12_city varchar(16), 
	contractor_12_state varchar(8), 
	contractor_12_zipcode varchar(6), 
	contractor_12_phone varchar(15), 
	contractor_13_type varchar(24), 
	contractor_13_name varchar(38), 
	contractor_13_address varchar(30), 
	contractor_13_city varchar(13), 
	contractor_13_state varchar(4), 
	contractor_13_zipcode varchar(6), 
	contractor_13_phone varchar(15), 
	contractor_14_type varchar(22), 
	contractor_14_name varchar(22), 
	contractor_14_address varchar(29), 
	contractor_14_city varchar(11), 
	contractor_14_state varchar(4), 
	contractor_14_zipcode varchar(6), 
	contractor_14_phone varchar(15), 
	contractor_15_type varchar(14), 
	contractor_15_name varchar(13), 
	contractor_15_address varchar(30), 
	contractor_15_city varchar(7), 
	contractor_15_state varchar(4), 
	contractor_15_zipcode integer, 
	contractor_15_phone varchar(32), 
	latitude float, 
	longitude float, 
	location varchar(40)
);"

	sed 's/\$//g' $file | psql -c "\copy input.building_permits from stdin with csv header;"
