*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Clean climate data											*
* INPUT			: podes2011.dta, podes2014.dta, podes2017.dta					*
* OUTPUT		: podes_processed.dta											*
*********************************************************************************

clear

* Open .dta
use "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\sketch\PODES data\podes2017.dta"

* Preprocessing Data

* Year
gen year=2018

* Village_ID
destring r101, replace
recast int r101
destring r102, replace
recast int r102
destring r103, replace
destring r104, replace
gen village_id=r101*10000000000+r102*1000000+r103*1000+r104
label variable village_id "Village ID"

* Village Type
rename r301 vil_type
drop if vil_type==3 | vil_type==4 // Drop Podes Transmigration Settlement Unit (UPT) or Transmigration Settlement Unit (SPT) observation
replace vil_type=0 if vil_type==2
label variable vil_type "=1 if village subsdistrict, =0 if urban subdistrict"

* Mainland Topography
rename r305b land_topo
replace land_topo=0 if land_topo==3
replace land_topo=1 if land_topo==1 | land_topo==2
label variable land_topo "=1 if slope/valleys, =0 vast land"

* Village Government Office Location
rename r306d office_loc
replace office_loc=0 if office_loc==2
label variable office_loc "=1 if inside region, =0 outside region"

* Village Bordering with Sea
rename r308a sea
replace sea=0 if sea==2
label variable sea "=1 if border with sea, =0 no border with sea"

* Village Bordering with Forest
rename r309a forest
replace forest=0 if forest==3
replace forest=1 if forest==1 | forest==2
label variable forest "=1 if inside or border with forest, =0 outside forest"

* Electricity 
rename r501a1 elec_pln
label variable elec_pln "Number of PLN electricity user household"
rename r501a2 elec_nonpln "Number of Non-PLN electricity user household"
rename r501b elec_na "Number of household without electricity"

* Cooking Fuel of Majority
rename r503b cook_fuel
label variable cook_fuel "Cooking Fuel Majority"
label define cook_fuel 1 "City gas" 2 "3 kgs LPG" 3 "> 3 kgs LPG" 4 "Kerosene" 5 "Firewood" 6 "Others"
label values cook_fuel cook_fuel

* River Transporation Use
rename r509b7k2 trans_river
replace trans_river=0 if trans_river==2
label variable trans_river "=1 if river used for transportation, =0 otherwise"

* Lake Transporation Use
rename r509b7k2 trans_lake
replace trans_lake=0 if trans_lake==2
label variable trans_lake "=1 if lake used for transportation, =0 otherwise"

* Natural Disaster
* Landfall Frequency
rename r601ak3 landfall_3
rename r601ak5 landfall_2
rename r601ak7 landfall_1
replace landfall_1=0 if misssing(landfall_1)
replace landfall_2=0 if misssing(landfall_2)
replace landfall_3=0 if misssing(landfall_3)
label variable landfall_1 "Landfall frequency [y-1]"
label variable landfall_2 "Landfall frequency [y-2]"
label variable landfall_3 "Landfall frequency [y-3]"

* Earthquake Frequency
rename r601dk3 earthq_3
rename r601dk5 earthq_2
rename r601dk7 earthq_1
replace earthq_1=0 if misssing(earthq_1)
replace earthq_2=0 if misssing(earthq_2)
replace earthq_3=0 if misssing(earthq_3)
label variable earthq_1 "Earthquake frequency [y-1]"
label variable earthq_2 "Earthquake frequency [y-2]"
label variable earthq_3 "Earthquake frequency [y-3]"

* Education and Health
* Elementary School
gen sch_el=r701ck2+r701ck3
label variable sch_el "Number of Elementary School"
* Junior High School
gen sch_jh=r701dk2+r701dk3 
label variable sch_jh "Number of Junior High School"
* Senior High School/ Vocational High School
gen sch_sh=r701ek2+r701ek3+r701fk2+r701fk3
label variable sch_sh "Number of Senior High School or Vocational High School"
* Higher Education
gen sch_uni=r701gk2+r701gk3 "Number of University"

* Poverty, Number of Poverty Statement 2017
rename r711b pov_let
label variable pov_ket "Number of poverty statement request"



* Save processed data

