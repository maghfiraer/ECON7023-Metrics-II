*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Clean data													*
* INPUT			: \podes_processed												*
* OUTPUT		: \output\figures, \output\table								*
* STATA VERSION	: Stata/MP 17.0 (March 2022)									*
*********************************************************************************

clear
use "./processed_data/podes_processed.dta"

* Clean strange data
drop if vil_subd_dis>9000
drop if vil_subd_cost>1000
drop if pov_let>99000
label variable unit_cost "Unit transportation cost in 000s Rp./km"
label variable vil_subd_cost "Transportation cost in 000s Rp."
label variable landfall_1 "Landfall occurence average per year"
label variable earthq_1 "Earthquake occurence average per year"
label variable sch_sh "Number of Senior High School"

* Rebalancing village
egen count1 = count(village_id), by(village_id)
drop if count1 == 1
order village_id 
order year unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf, after(village_id)
drop count1


*********************************************************************************
* Create Summary Statistics														*
*********************************************************************************

* Create Space in the Label
foreach x of varlist unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf {
  local t : var label `x'
  local t = "\hspace{0.25cm} `t'"
  lab var `x' "`t'"
}

* Produce Summary Statistics
* Table 1 Option A
est clear
estpost tabstat ///
unit_cost vil_subd_dur landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal

esttab using "./output/table/table1.tex", replace ///
refcat(unit_cost "\emph{Transportation}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
	 cells(mean(fmt(2)) sd(par)) nostar  nonumber unstack ///
  nomtitle nonote obs label  ///
   collabels(none) ///
   eqlabels("2014" "2018") ///  
   nomtitles

* Table 1 Option B

est clear
estpost tabstat ///
unit_cost vil_subd_dur landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal
esttab, cells("mean sd min max count")
estout, cells("mean sd min max count")

esttab using "./output/table/table1b.tex", replace ////
refcat(unit_cost "\emph{Transportation}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
 cells("mean(fmt(2)) sd min max count(fmt(0))") nostar unstack nonumber ///
  compress nomtitle nonote noobs label booktabs ///
  eqlabels("2014" "2018") ///
  collabels("Mean" "S.D." "Min" "Max" "Obs.")
  
* Table 1 Option C
est clear
estpost tabstat ///
unit_cost vil_subd_dur landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1 & dist_prog==1, ///
by(year) c(stat) stat(mean sd min max n) nototal

esttab using "./output/table/table1c.tex", replace ///
refcat(unit_cost "\emph{Transportation}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
	 cells(mean(fmt(2)) sd(par)) nostar  nonumber unstack ///
  nomtitle nonote obs label  ///
   collabels(none) ///
   eqlabels("2014" "2018") ///  
   nomtitles

* Table 1 Option D

est clear
estpost tabstat ///
unit_cost vil_subd_dur landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1 & dist_prog==1, ///
by(year) c(stat) stat(mean sd min max n) nototal
esttab, cells("mean sd min max count")
estout, cells("mean sd min max count")

esttab using "./output/table/table1d.tex", replace ////
refcat(unit_cost "\emph{Transportation Cost}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
 cells("mean(fmt(2)) sd min max count(fmt(0))") nostar unstack nonumber ///
  compress nomtitle nonote noobs label booktabs ///
  eqlabels("2014" "2018") ///
  collabels("Mean" "S.D." "Min" "Max" "Obs.")



*********************************************************************************
* Instrument Evaluation															*
*********************************************************************************

* Correlation
est clear
estpost corr inc_vf pov_let elec_pln if prov_prog==1, matrix listwise
esttab using "./output/table/firststagecorr.tex", replace unstack not noobs compress b(2) nonote label


* Compare First Stage Regression on VF
est clear
eststo: reg inc_vf pov_let if prov_prog==1, robust
eststo: reg inc_vf pov_let elec_pln if prov_prog==1, robust
eststo: reg inc_vf pov_let elec_pln earthq_1 if prov_prog==1, robust
eststo: reg inc_vf pov_let elec_pln earthq_1 land_topo forest sea trans_river if prov_prog==1, robust
eststo: reg inc_vf pov_let elec_pln earthq_1 sea trans_river if prov_prog==1, robust
esttab using "./output/table/firststageVF.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) r2 ar2 scalar(F) ///
 booktabs
 *addnotes("Add comment here")
 
est clear
eststo: reg prog_par pov_let if prov_prog==1, robust
eststo: reg prog_par pov_let elec_pln if prov_prog==1, robust
eststo: reg prog_par pov_let elec_pln earthq_1 if prov_prog==1, robust
eststo: reg prog_par pov_let elec_pln earthq_1 land_topo forest sea trans_river if prov_prog==1, robust
eststo: reg prog_par pov_let elec_pln earthq_1 sea trans_river if prov_prog==1, robust
esttab using "./output/table/firststageD.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) r2 ar2 scalar(F) ///
 booktabs
 *addnotes("Add comment here")




*********************************************************************************
* Run Regression																*
*********************************************************************************

* Hausman (1978)
xtreg unit_cost prog_par inc_vf if prov_prog==1, fe
estimates store fixed
xtreg unit_cost prog_par inc_vf if prov_prog==1, re
estimates store random
hausman fixed random, sigmamore

* Simple POLS
est clear

eststo: xtreg unit_cost prog_par inc_vf vil_subd_dur pov_let sch_sh land_topo trans_river if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "Province"
 estadd local  Con "Yes"

eststo: xtreg unit_cost prog_par inc_vf vil_subd_dur pov_let sch_sh land_topo trans_river i.year if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "Province"
 estadd local  Con "Yes"
 
 eststo: xtreg unit_cost prog_par inc_vf if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "Province"
 estadd local  Con "No"

eststo: xtreg unit_cost prog_par inc_vf i.year if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "Province"
 estadd local  Con "No"
 
eststo: xtreg unit_cost prog_par inc_vf vil_subd_dur pov_let sch_sh land_topo trans_river if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "District"
 estadd local  Con "Yes"

eststo: xtreg unit_cost prog_par inc_vf vil_subd_dur pov_let sch_sh land_topo trans_river i.year if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "District"
 estadd local  Con "Yes"
 
 eststo: xtreg unit_cost prog_par inc_vf if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "District"
 estadd local  Con "No"

eststo: xtreg unit_cost prog_par inc_vf i.year if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "District"
 estadd local  Con "No"

esttab using "./output/table/POLS.tex", replace   ///
 b(3) se(3) ///
 keep(prog_par inc_vf) ///
 star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs nonotes nomtitle coeflabels(inc_vf "Village Fund transfer") compress alignment(D{.}{.}{-1}) ///
 scalars("Sa Sample" "Con Controls" "TE Time Fixed Effects" "FE Village Fixed Effects") sfmt(3 0)

* FEIV
global controls vil_subd_dur sch_sh land_topo trans_river
est clear

eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) $controls if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "Province"
 estadd local  Con "Yes"

eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) $controls y18 if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "Province"
 estadd local  Con "Yes"
 
 eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "Province"
 estadd local  Con "No"

eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) y18 if prov_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "Province"
 estadd local  Con "No"
 
eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) $controls if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "District"
 estadd local  Con "Yes"

eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) $controls y18 if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "District"
 estadd local  Con "Yes"
 
 eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "No"
 estadd local  Sa "District"
 estadd local  Con "No"

eststo: xtivreg2 unit_cost (prog_par inc_vf=pov_let elec_pln earthq_1) y18 if dist_prog==1 & vil_type==1, fe robust
 estadd local  FE "Yes"
 estadd local  TE "Yes"
 estadd local  Sa "District"
 estadd local  Con "No"

esttab using "./output/table/FEIV.tex", replace   ///
 b(3) se(3) ///
 keep(prog_par inc_vf y18) ///
 star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs nonotes nomtitle coeflabels(inc_vf "Village Fund transfer") compress alignment(D{.}{.}{-1}) ///
 scalars("Sa Sample" "Con Controls" "TE Time Fixed Effects" "FE Village Fixed Effects") sfmt(3 0)

xtreg unit_cost prog_par inc_vf i.year if dist_prog==1 & vil_type==1, fe robust
xtreg unit_cost prog_par inc_vf pov_let elec_pln earthq_1 sea trans_river land_topo forest sch_sh sch_jh i.year if dist_prog==1 & vil_type==1, fe robust


* PSM Abadie (2016)
keep if prog_par
keep match1
bysort match1: gen weight=_N
by match1: keep if _n==1
ren match1 ob


* Main regression table
xtivreg2 unit_cost (prog_par inc_vf = pov_let elec_pln earthq_1 sea trans_river) land_topo forest sch_sh sch_jh y18 if prov_prog==1 & vil_type==1, fe robust

xtivreg2 unit_cost (prog_par inc_vf = pov_let elec_pln earthq_1 sea trans_river) y18 if prov_prog==1 & vil_type==1, fe robust

xtivreg2 unit_cost (prog_par inc_vf = pov_let elec_pln) y18 if prov_prog==1 & vil_type==1, fe robust
xtivreg2 unit_cost (prog_par inc_vf = pov_let elec_pln) y18 if dist_prog==1 & vil_type==1, fe robust

xtivreg2 unit_cost prog_par (inc_vf = pov_let elec_pln) y18 if prov_prog==1 & vil_type==1, fe robust
xtivreg2 unit_cost prog_par (inc_vf = pov_let elec_pln) y18 if dist_prog==1 & vil_type==1, fe robust

xtivreg2 unit_cost prog_par (inc_vf = pov_let elec_pln sea trans_river) y18 if prov_prog==1 & vil_type==1, fe robust

xtivreg2 lucost (prog_par lvf = lpov lpln earthq_1 sea trans_river) land_topo forest sch_sh sch_jh y18 if prov_prog==1 & vil_type==1, fe robust

xtivreg2 lucost (prog_par lvf = lpov lpln earthq_1 sea trans_river) land_topo forest sch_sh sch_jh y18 if dist_prog==1 & vil_type==1, fe robust

xtivreg2 lucost (prog_par inc_vf = pov_let elec_pln earthq_1 sea trans_river) land_topo forest sch_sh sch_jh y18 if prov_prog==1 & vil_type==1, fe robust
xtivreg2 unit_cost (prog_par inc_vf = pov_let elec_pln land_topo forest sea trans_river) earthq_1 sch_sh sch_jh y18 if dist_prog==1 & vil_type==1, fe robust
xtivreg2 unit_cost prog_par (inc_vf = pov_let elec_pln earthq_1 land_topo forest sea trans_river) sch_sh sch_jh y18 if prov_prog==1 & vil_type==1, fe robust
xtivreg2 lucost prog_par (inc_vf = pov_let elec_pln earthq_1 land_topo forest sea trans_river) sch_sh sch_jh y18 if prov_prog==1 & vil_type==1, fe robust
xtivreg2 lucost prog_par (inc_vf = pov_let elec_pln earthq_1 land_topo forest sea trans_river) sch_sh sch_jh y18 if dist_prog==1 & vil_type==1, fe robust
xtivreg2 unit_cost prog_par (inc_vf = pov_let elec_pln earthq_1 land_topo forest sea trans_river) sch_sh sch_jh y18 if dist_prog==1 & vil_type==1, fe robust


*********************************************************************************
* Run Regression																*
*********************************************************************************
global controls age* ttl_exp* tenure* not_smsa south union
est clear

*POLS
eststo: xtreg unit_cost $controls, fe vce(robust)
 estadd local  FE "Yes"
 estadd local  TE "No"
 
eststo: xtreg lucost $controls i.year, re vce(robust)
 estadd local  FE  "No"
 estadd local  TE  "Yes"
 
eststo: xtreg lucost $controls i.year, fe vce(robust)
 estadd local  FE  "Yes"
 estadd local  TE  "Yes"
 
esttab using "./graphs/guide80/regression2.tex", replace   ///
 b(3) se(3) ///
 keep($controls) ///
 star(* 0.10 ** 0.05 *** 0.01) ///
 label booktabs nonotes nomtitle collabels(none) compress alignment(D{.}{.}{-1}) ///
 scalars("TE Time fixed effects" "FE Panel fixed effects") sfmt(3 0)
