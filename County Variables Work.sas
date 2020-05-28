/* Identify information for Dr. Felix at the county levels 

Data Sources

AHRF Data:
county pop total, percent county pop minority/nonwhite race, percent county pop age = 65, and county per capita income CBSA Code

Other File:
county obesity rate,  pct count rural

Will grab information from AHRF and other sources for the NH study with Dr. Felix

Program: Robert Schuldt
Email  : rschuldt@uams.edu

05/28/2020

*/
libname ahrf18 '\\uams\COPH\Health_Policy_Management\Data\AHRF\2018-2019';

%let year = 18;

data ahrf_&year;
	set ahrf18.ahrf2019;
		keep  F00002 F1198417 F1198418 F1390817 F1390917 F1547117 F0978117 F1406718;

	run;

data ahrf_clean;
	set ahrf_18;

		rename F00002 = FIPS; /* Fips state and county code*/
 		rename F1198417 =  countypop17; /* We have pop estimates for each year*/
		rename F1198418 = countypop18;
		rename F1390817  = whitemalepop17; /* We only have total white pop estimate for 2017 as combo of men and women*/
		rename F1390917  = whitefemalepop17;
		rename F1547117  = age65plus17; 
		rename F0978117  = percapincome17; /* Per capita income 2017*/
		rename F1406718 = CBSA_code;
run;

Proc freq;
table cbsa_code;
run;

data ahrf_set;
	set ahrf_clean;
		/* Create a total white variable to calculate no white population*/
		total_white_17 = whitemalepop17+whitefemalepop17;
		/* percent non white for 2017*/
		non_white_17 =  (1 - total_white_17/countypop17)*100;
		/* percent non white for 2018*/
		non_white_18 = (1 - total_white_17/countypop18)*100;
		/* percent 65+  in 2017*/
		age_65_plus_17 = (age65plus17/countypop17)*100;
		/* percent 65+  in 2018*/
		age_65_plus_18 = (age65plus17/countypop18)*100;

	keep  fips  countypop17 countypop18 whitemalepop17 whitefemalepop17 age65plus17 percapincome17 age_65_plus_18
	age_65_plus_17 non_white_18 non_white_17 total_white_17 CBSA_code;

		run;
/* breaking the data into 2018 and 2017 sets I can just stack for ease of later work since I want two different years */
data ahrf17; 
	set ahrf_set; 
	keep fips CBSA_code countypop17 total_white_17  age65plus17 age_65_plus_17 non_white_17 percapincome17 year;
	year = 2017;
	rename countypop17 =countypop;
	rename total_white_17 = total_white;
	rename age65plus17 = age65plus;
	rename age_65_plus_17 = age_65_plus;
	rename non_white_17 = non_white;

	run;
data ahrf18; 
	set ahrf_set; 
	keep fips CBSA_code countypop18 total_white_17  age65plus17 age_65_plus_18 non_white_18 percapincome17 year;
	year = 2018;
		rename countypop18 =countypop;
	rename total_white_17 = total_white;
	rename age65plus17 = age65plus;
	rename age_65_plus_18 = age_65_plus;
	rename non_white_18 = non_white;
	run;


		/*Grabbing obesity rates and the percent living rural by county level from the County Health Rankings*/
%macro imports(file);
proc import datafile = "C:\Users\3043340\Box\Dr. Felix Work\County Level NH work\&file "
dbms = xlsx out = &file replace;
run;

%mend imports;
%imports(obesity_2018)
%imports(obesity_2017)
%imports(rural2018)
%imports(rural2017)

proc sql;
create table ahrf_county_18 as
select *
from 
ahrf18 a, 
obesity_2018 b,
rural2018 c 
where 
a.fips = b.fips and
a.fips = c.fips
;
quit;
proc sql;
create table ahrf_county_17 as
select *
from 
ahrf17 a, 
obesity_2017 b,
rural2017 c 
where 
a.fips = b.fips and
a.fips = c.fips
;
quit;

data 'C:\Users\3043340\Box\Dr. Felix Work\County Level NH work\nh_county.sas7bdat';
	set ahrf_county_17 ahrf_county_18;
	run;

