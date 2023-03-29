*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Main Code														*
* INPUT			: podes2011.dta, podes2014.dta, podes2017.dta					*
* OUTPUT		: /figures, /table												*
* STATA VERSION	: Stata/MP 17.0 (March 2022)									*
*********************************************************************************

clear
macro drop _all
set more off, permanently
capture log close
capture graph drop _all

cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project"

* create log file
local c_time_date = "`c(current_date)'"+"_" +"`c(current_time)'"
local time_string = subinstr("`c_time_date'", ":", "_", .)
local time_string = subinstr("`time_string'", " ", "_", .)
log using "output\logs\final_project_`time_string'.log", replace

*********************************************************************************
* Cleaning data																	*
*********************************************************************************
do "code\clean_data.do"

*********************************************************************************
* Analyzing data																*
*********************************************************************************

* Produce Summary Statistics
est clear
estpost tabstat ///
vil_subd_dis vil_subd_mode vil_subd_dur vil_subd_cost office_loc land_topo sea forest elec_pln elec_nonpln elec_na trans_river trans_lake landfall_3 landfall_2 landfall_1 earthq_3 earthq_2 earthq_1 sch_el sch_jh sch_sh sch_uni pov_let inc_dom inc_vf inc_rsg if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal

esttab, cells(mean(fmt(2)) sd(par) count(fmt(0))) nostar  nonumber unstack ///
  nomtitle nonote noobs label  ///
   collabels(none) gap ///
   eqlabels("2011" "2014" "2018") ///  
   nomtitles

foreach x of varlist vil_subd_dis vil_subd_mode vil_subd_dur vil_subd_cost office_loc land_topo sea forest elec_pln elec_nonpln elec_na trans_river trans_lake landfall_3 landfall_2 landfall_1 earthq_3 earthq_2 earthq_1 sch_el sch_jh sch_sh sch_uni pov_let inc_dom inc_vf inc_rsg {
  local t : var label `x'
  local t = "\hspace{0.25cm} `t'"
  lab var `x' "`t'"
}





log close

clear

exit