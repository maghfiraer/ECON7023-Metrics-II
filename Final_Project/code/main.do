*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Main Code														*
* INPUT			: podes2011.dta, podes2014.dta, podes2017.dta					*
* OUTPUT		: \output\figures, \output\table, \output\logs					*
* STATA VERSION	: Stata/MP 17.0 (March 2022)									*
*********************************************************************************

clear
macro drop _all
set more off, permanently
capture log close
capture graph drop _all

* Set the location of project directory/clone location
cd "/Users/macbook/Documents/GitHub/ECON7023-Metrics-II/Final_Project"

* create log file
local c_time_date = "`c(current_date)'"+"_" +"`c(current_time)'"
local time_string = subinstr("`c_time_date'", ":", "_", .)
local time_string = subinstr("`time_string'", " ", "_", .)
*log using "output\logs\final_project_`time_string'.log", replace

*********************************************************************************
* Cleaning data																	*
*********************************************************************************
do "./code/clean_data.do"

*********************************************************************************
* Analyzing data																*
*********************************************************************************

do "./code/analysis.do"





*log close

clear

exit
