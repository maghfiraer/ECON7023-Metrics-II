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
unit_cost landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal

esttab using "./output/table/table1.tex", replace ///
refcat(unit_cost "\emph{Transportation Cost}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
	 cells(mean(fmt(2)) sd(par)) nostar  nonumber unstack ///
  nomtitle nonote obs label  ///
   collabels(none) ///
   eqlabels("2014" "2018") ///  
   nomtitles

* Table 1 Option B

est clear
estpost tabstat ///
unit_cost landfall_1 earthq_1 elec_pln sch_jh sch_sh inc_vf if vil_type==1, ///
by(year) c(stat) stat(mean sd min max n) nototal
esttab, cells("mean sd min max count")
estout, cells("mean sd min max count")

esttab using "./output/table/table1b.tex", replace ////
refcat(unit_cost "\emph{Transportation Cost}" landfall_1 "\vspace{0.05em} \\ \emph{Natural Disaster}" elec_pln "\vspace{0.05em} \\ \emph{Infrastructure}" inc_vf "\vspace{0.05em} \\ \emph{Inter-government Transfer}", nolabel) ///
 cells("mean(fmt(2)) sd min max count(fmt(0))") nostar unstack nonumber ///
  compress nomtitle nonote noobs label booktabs ///
  eqlabels("2014" "2018") ///
  collabels("Mean" "S.D." "Min" "Max" "Obs.")


*********************************************************************************
* Create Treatment Dummy														*
*********************************************************************************
clear

* Import xls
import excel "./data/List_SPBU_BBM_1_Harga_rev.xlsx", sheet("Sheet1") firstrow allstring clear

keep MOR PROPINSI KABUPATEN KECAMATAN ALAMAT Year Supplier Treatment subd_id
destring Year, replace
rename Year prog_year
destring Treatment, replace
rename Treatment prog_par
destring subd_id, replace

* Year
gen year=2018
sort subd_id
quietly by subd_id: gen dup= cond(_N==1,0,_n)
drop if dup>1
drop dup

* Save processed data
save "./processed_data/list_SPBU.dta", replace

keep year prog_par subd_id

* Merge VF transfer from Kemendes
merge 1:m subd_id year using "./processed_data/podes_processed.dta"
drop _merge

order village_id 
order year prog_par unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf, after(village_id)

replace prog_par=0 if missing(prog_par)

* Generate Subdistrict Dummy with Treated Subdistrict Dummy
egen count1 = sum(prog_par), by(subd_id)
gen dist_prog = 0
replace dist_prog =1 if count1>0
drop count1

* Generate District with Treated Subdistrict Dummy
egen count1 = sum(prog_par), by(dist_id)
gen dist_prog = 0
replace dist_prog =1 if count1>0
drop count1

* Generate Province with Treated Subdistrict Dummy
egen count1 = sum(prog_par), by(id_prov)
gen prov_prog = 0
replace prov_prog =1 if count1>0
drop count1

* Rebalancing village
egen count1 = count(village_id), by(village_id)
drop if count1 == 1
order village_id 
order year unit_cost vil_subd_cost vil_subd_dis vil_subd_mode vil_subd_dur land_topo sea forest trans_river landfall_1 earthq_1 elec_pln elec_nonpln sch_el sch_jh sch_sh sch_uni pov_let inc_vf, after(village_id)
drop count1

save "./processed_data/podes_processed.dta", replace

