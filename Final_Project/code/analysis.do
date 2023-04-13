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
drop if vil_subd_dis<100
drop if vil_subd_cost<1000
egen count = count(village_id), by(village_id)
drop if count == 1


* Produce Summary Statistics
* Table 1 Option A
est clear
estpost tabstat ///
vil_subd_dis vil_subd_mode vil_subd_dur vil_subd_cost land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal

cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project"
esttab using "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\output\table\table1.tex", replace ///
	 cells(mean(fmt(2)) sd(par) count(fmt(0))) nostar  nonumber unstack ///
  nomtitle nonote noobs label  ///
   collabels(none) gap ///
   eqlabels("2014" "2018") ///  
   nomtitles

* Table 1 Option B
est clear
estpost tabstat ///
 unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest elec_pln elec_nonpln trans_river landfall_1 earthq_1 sch_el sch_jh sch_sh sch_uni pov_let inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal
esttab, cells("mean sd min max count")
estout, cells("mean sd min max count")

esttab using "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\output\table\table1b.tex", replace ////
refcat(unit_cost "\emph{Transportation}" land_topo "\vspace{0.1em} \\ \emph{Geographic and Natural Disaster}" elec_pln "\vspace{0.1em} \\ \emph{Infrastructure}", nolabel) ///
 cells("mean(fmt(%8.0fc %8.0fc %8.0fc %8.0fc  2)) sd min max count(fmt(0))") nostar unstack nonumber ///
  compress nomtitle nonote noobs label booktabs ///
  collabels("Mean" "SD" "Min" "Max" "N")