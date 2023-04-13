*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Clean data													*
* INPUT			: podes_processed												*
* OUTPUT		: \output\figures, \output\table								*
* STATA VERSION	: Stata/MP 17.0 (March 2022)									*
*********************************************************************************

clear
use "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\processed_data\podes_processed.dta"

* Clean strange data
drop if vil_subd_dis>9000
drop if vil_subd_cost>90000
drop if pov_let>99000
label variable unit_cost "Unit transportation cost in 000s Rp./km"
label variable vil_subd_cost "Transportation cost in 000s Rp."
label variable landfall_1 "Landfall occurence average per year"
label variable earthq_1 "Earthquake occurence average per year"

foreach x of varlist unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf {
  local t : var label `x'
  local t = "\hspace{0.25cm} `t'"
  lab var `x' "`t'"
}


* Rebalancing village
egen count1 = count(village_id), by(village_id)
drop if count1 == 1
order village_id 
order year unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf, after(village_id)
describe

* Produce Summary Statistics
* Table 1 Option A
est clear
estpost tabstat ///
unit_cost vil_subd_cost landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal

cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project"
esttab using "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\output\table\table1.tex", replace ///
refcat(unit_cost "\emph{Transportation Cost}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
	 cells(mean(fmt(2)) sd(par)) nostar  nonumber unstack ///
  nomtitle nonote obs label  ///
   collabels(none) ///
   eqlabels("2014" "2018") ///  
   nomtitles

* Table 1 Option B

est clear
estpost tabstat ///
unit_cost vil_subd_cost landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal
esttab, cells("mean sd min max count")
estout, cells("mean sd min max count")

esttab using "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\output\table\table1b.tex", replace ////
refcat(unit_cost "\emph{Transportation Cost}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
 cells("mean(fmt(2)) sd min max count(fmt(0))") nostar unstack nonumber ///
  compress nomtitle nonote noobs label booktabs ///
  eqlabels("2014" "2018") ///
  collabels("Mean" "S.D." "Min" "Max" "Obs.")