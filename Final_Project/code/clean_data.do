*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Clean data													*
* INPUT			: kemendes.xls, podes2011.dta, podes2014.dta, podes2017.dta		*
* OUTPUT		: \data\podes_processed.dta										*
* STATA VERSION	: Stata/MP 17.0 (March 2022)									*
*********************************************************************************

*********************************************************************************
* Structuring kemendes.xls														*
*********************************************************************************
clear

* Import xls
import excel "./data/kemendes.xlsx", sheet("UTAMA") firstrow allstring clear
drop in 74954/74957

* Year
gen year=2018

* Village_ID
replace KODEBPS2019="." if KODEBPS2019=="Tidak Ada"
destring KODEBPS2019, replace
rename KODEBPS2019 village_id
label variable village_id "Village ID"

*IDM and Status 2018
destring IDM2018, replace
rename IDM2018 idm18
label variable idm18 "Village Index"
rename STATUSIDM2018 sidm18
label variable sidm18 "Village Status"

* Government VF Allocation
replace PengeluaranBidangPembangunanD="." if PengeluaranBidangPembangunanD=="Tidak Ada Data"
replace PengeluaranBidangPemberdayaan="." if PengeluaranBidangPemberdayaan=="Tidak Ada Data"
replace P="." if P=="Tidak Ada Data"
replace Q="." if Q=="Tidak Ada Data"
destring PengeluaranBidangPembangunanD, replace
destring PengeluaranBidangPemberdayaan, replace
destring P, replace
destring Q, replace
replace P=P/1000000
replace Q=Q/1000000
replace PengeluaranBidangPembangunanD=PengeluaranBidangPembangunanD/1000000
replace PengeluaranBidangPemberdayaan=PengeluaranBidangPemberdayaan/1000000
gen inc_vf=PengeluaranBidangPemberdayaan
label variable inc_vf "Revenue from village fund transfer"

keep year village_id idm18 sidm18 inc_vf
drop if missing(village_id)

* Save processed data
save "./processed_data/kemendes.dta", replace

*********************************************************************************
* Save without inc_vf															*
*********************************************************************************

drop year inc_vf

* Save processed data
save "./processed_data/kemendes_novf.dta", replace

*********************************************************************************
* Structuring podes2017.dta														*
*********************************************************************************
clear

* Open .dta
use "./data/podes2017.dta"

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
gen double village_id=r101*100000000+r102*1000000+r103*1000+r104
label variable village_id "Village ID"
gen double subd_id=r101*100000+r102*1000+r103
label variable subd_id "Subdistrict ID"
gen double dist_id=r101*100+r102
label variable dist_id "District ID"

* Village, Subdistrict, District, Province Name
rename r101n name_prov
rename r101 id_prov
rename r102n name_d
rename r102 id_d
rename r103n name_subd
rename r103 id_subd
rename r104n name_vil
rename r104 id_vil

* Village Type
rename r301 vil_type
*drop if vil_type==3 | vil_type==4 // Drop Podes Transmigration Settlement Unit (UPT) or Transmigration Settlement Unit (SPT) observation
replace vil_type=0 if vil_type==2 | vil_type==3 | vil_type==4
label variable vil_type "=1 if village subsdistrict, =0 if non-village subdistrict"

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
rename r501a2 elec_nonpln
label variable elec_nonpln "Number of Non-PLN electricity user household"
rename r501b elec_na
label variable elec_na "Number of household without electricity"

* Cooking Fuel of Majority
rename r503b cook_fuel
label variable cook_fuel "Cooking Fuel Majority"
replace cook_fuel=cook_fuel-1 if cook_fuel>2
label define cook_fuel 1 "City gas" 2 "LPG" 3 "Kerosene" 4 "Firewood" 5 "Others"
label values cook_fuel cook_fuel

* River Transporation Use
rename r509b7k2 trans_river
replace trans_river=0 if trans_river==2
label variable trans_river "=1 if river used for transportation, =0 otherwise"

* Lake Transporation Use
rename r509b7k4 trans_lake
replace trans_lake=0 if trans_lake==2
label variable trans_lake "=1 if lake used for transportation, =0 otherwise"

* Natural Disaster
* Landfall Frequency
rename r601ak3 landfall_3
rename r601ak5 landfall_2
rename r601ak7 landfall_1
replace landfall_1=0 if missing(landfall_1)
replace landfall_2=0 if missing(landfall_2)
replace landfall_3=0 if missing(landfall_3)
label variable landfall_1 "Landfall frequency [y-1]"
label variable landfall_2 "Landfall frequency [y-2]"
label variable landfall_3 "Landfall frequency [y-3]"

* Earthquake Frequency
rename r601dk3 earthq_3
rename r601dk5 earthq_2
rename r601dk7 earthq_1
replace earthq_1=0 if missing(earthq_1)
replace earthq_2=0 if missing(earthq_2)
replace earthq_3=0 if missing(earthq_3)
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
gen sch_uni=r701gk2+r701gk3 
label variable sch_uni "Number of University"

* Poverty, Number of Poverty Statement 2017
rename r711b pov_let
label variable pov_let "Number of poverty statement request"

* Transportation, Communication, and Information

* Transportation from village office to subdistrict office
* Transport Mode
rename r1002ak2 vil_subd_mode
label variable vil_subd_mode "Transport Mode from Village Office to Subdistrict Office"
replace vil_subd_mode=3 if vil_subd_mode>3
label define vil_subd_mode 1 "Public Transport" 2 "Private Vehicles" 3 "Others"
label values vil_subd_mode vil_subd_mode

* Distance (km)
rename r1002ak5 vil_subd_dis
label variable vil_subd_dis "Distance from Village Office to Subdistrict Office"

* Travel Duration (hr)
gen vil_subd_dur=r1002ajm+r1002ame/60
label variable vil_subd_dur "Travel duration from Village Office to Subdistrict Office"

* Tranport Cost
rename r1002ak7 vil_subd_cost
label variable vil_subd_cost "Transportation cost from Village Office to Subdistrict Office in 000s Rp."

* Cleaning data

* Transportation from village office to neighboring subdistrict office
* Transport Mode
rename r1002bk2 vil_nsubd_mode
label variable vil_nsubd_mode "Transport Mode from Village Office to Neighbouring Subdistrict Office"
replace vil_nsubd_mode=3 if vil_nsubd_mode>3
label define vil_nsubd_mode 1 "Public Transport" 2 "Private Vehicles" 3 "Others"
label values vil_nsubd_mode vil_nsubd_mode

* Distance (km)
rename r1002bk5 vil_nsubd_dis
label variable vil_nsubd_dis "Distance from Village Office to Neighbouring Subdistrict Office"

* Travel Duration (hr)
gen vil_nsubd_dur=r1002bjm+r1002bme/60
label variable vil_nsubd_dur "Travel duration from Village Office to Neighbouring Subdistrict Office"

* Tranport Cost
rename r1002bk7 vil_nsubd_cost
label variable vil_nsubd_cost "Transportation cost from Village Office to Neighbouring Subdistrict Office in 000s Rp."

* Village Governance
* Government Domestic Income
gen inc_dom=.

* Government VF Allocation
* gen inc_vf=.

* Government Revenue Sharing / Grant
gen inc_rsg=.
label variable inc_dom "Revenue generated locally"
*label variable inc_vf "Revenue from village fund transfer"
label variable inc_rsg "Revenue from other sources"

keep year village_id subd_id dist_id name_prov name_d name_subd name_vil id_prov id_d id_subd id_vil vil_type land_topo office_loc sea forest elec_pln elec_nonpln elec_na cook_fuel trans_river landfall_1 landfall_2 landfall_3 earthq_1 earthq_2 earthq_3 sch_el sch_jh sch_sh sch_uni pov_let vil_subd_mode vil_subd_dis vil_subd_dur vil_subd_cost vil_nsubd_mode vil_nsubd_dis vil_nsubd_dur vil_nsubd_cost inc_dom inc_rsg

* Merge VF transfer from Kemendes
merge 1:1 village_id year using "./processed_data/kemendes.dta"
drop _merge idm18 sidm18

* Save processed data
save "./processed_data/podes17_processed.dta", replace

*********************************************************************************
* Structuring podes2014.dta														*
*********************************************************************************

clear

* Open .dta
use "./data/podes2014.dta"

* Preprocessing Data

* Year
gen year=2014

* Village_ID
destring r101, replace
recast int r101
destring r102, replace
recast int r102
destring r103, replace
destring r104, replace
gen double village_id=r101*100000000+r102*1000000+r103*1000+r104
label variable village_id "Village ID"
gen double subd_id=r101*100000+r102*1000+r103
label variable subd_id "Subdistrict ID"
gen double dist_id=r101*100+r102
label variable dist_id "District ID"

* Village, Subdistrict, District, Province Name
rename r101n name_prov
rename r101 id_prov
rename r102n name_d
rename r102 id_d
rename r103n name_subd
rename r103 id_subd
rename r104n name_vil
rename r104 id_vil

* Village Type
destring r301, replace
rename r301 vil_type
*drop if vil_type==3 | vil_type==4 | vil_type==5 // Drop Podes Transmigration Settlement Unit (UPT) or Transmigration Settlement Unit (SPT) observation
replace vil_type=0 if vil_type==2 | vil_type==3 | vil_type==4 | vil_type==5
label variable vil_type "=1 if village subsdistrict, =0 if non-village subdistrict"

* Mainland Topography
destring r305b, replace
rename r305b land_topo
replace land_topo=0 if land_topo==3
replace land_topo=1 if land_topo==1 | land_topo==2
label variable land_topo "=1 if slope/valleys, =0 vast land"

* Village Government Office Location
destring r306a, replace
rename r306a office_loc
replace office_loc=0 if office_loc>1
label variable office_loc "=1 if inside region, =0 outside region"

* Village Bordering with Sea
destring r307a, replace
rename r307a sea
replace sea=0 if sea==2
label variable sea "=1 if border with sea, =0 no border with sea"

* Village Bordering with Forest
destring r308a, replace
rename r308a forest
replace forest=0 if forest==3
replace forest=1 if forest==1 | forest==2
label variable forest "=1 if inside or border with forest, =0 outside forest"

* Electricity 
rename r501a1 elec_pln
label variable elec_pln "Number of PLN electricity user household"
rename r501a2 elec_nonpln
label variable elec_nonpln "Number of Non-PLN electricity user household"
rename r501b elec_na
label variable elec_na "Number of household without electricity"

* Cooking Fuel of Majority
destring r503, replace
rename r503 cook_fuel
label variable cook_fuel "Cooking Fuel Majority" // Need to be changed category
label define cook_fuel 1 "City gas" 2 "LPG" 3 "Kerosene" 4 "Firewood" 5 "Others"
label values cook_fuel cook_fuel

* River Transporation Use
destring r508b6_k2, replace
rename r508b6_k2 trans_river
replace trans_river=0 if trans_river==2
label variable trans_river "=1 if river used for transportation, =0 otherwise"

* Lake Transporation Use
destring r508b6_k4, replace
rename r508b6_k4 trans_lake
replace trans_lake=0 if trans_lake==2
label variable trans_lake "=1 if lake used for transportation, =0 otherwise"

* Natural Disaster
* Landfall Frequency
rename r601a_k3 landfall_3
rename r601a_k5 landfall_2
rename r601a_k7 landfall_1
replace landfall_1=0 if missing(landfall_1)
replace landfall_2=0 if missing(landfall_2)
replace landfall_3=0 if missing(landfall_3)
label variable landfall_1 "Landfall frequency [y-1]"
label variable landfall_2 "Landfall frequency [y-2]"
label variable landfall_3 "Landfall frequency [y-3]"

* Earthquake Frequency
rename r601d_k3 earthq_3
rename r601d_k5 earthq_2
rename r601d_k7 earthq_1
replace earthq_1=0 if missing(earthq_1)
replace earthq_2=0 if missing(earthq_2)
replace earthq_3=0 if missing(earthq_3)
label variable earthq_1 "Earthquake frequency [y-1]"
label variable earthq_2 "Earthquake frequency [y-2]"
label variable earthq_3 "Earthquake frequency [y-3]"

* Education and Health
* Elementary School
gen sch_el=r701b_k2+r701b_k3
label variable sch_el "Number of Elementary School"
* Junior High School
gen sch_jh=r701c_k2+r701c_k3 
label variable sch_jh "Number of Junior High School"
* Senior High School/ Vocational High School
gen sch_sh=r701d_k2+r701d_k3+r701e_k2+r701e_k3
label variable sch_sh "Number of Senior High School or Vocational High School"
* Higher Education
gen sch_uni=r701f_k2+r701f_k3 
label variable sch_uni "Number of University"

* Poverty, Number of Poverty Statement 2017
rename r711b pov_let
label variable pov_let "Number of poverty statement request"

* Transportation, Communication, and Information

* Transportation from village office to subdistrict office
* Transport Mode
destring r1002a_k4, replace
rename r1002a_k4 vil_subd_mode
label variable vil_subd_mode "Transport Mode from Village Office to Subdistrict Office"
replace vil_subd_mode=3 if vil_subd_mode>3
label define vil_subd_mode 1 "Public Transport" 2 "Private Vehicles" 3 "Others"
label values vil_subd_mode vil_subd_mode

* Distance (km)
rename r1002a_k2 vil_subd_dis
label variable vil_subd_dis "Distance from Village Office to Subdistrict Office"

* Travel Duration (hr)
gen vil_subd_dur=r1002a_k3
label variable vil_subd_dur "Travel duration from Village Office to Subdistrict Office"

* Tranport Cost
rename r1002a_k7 vil_subd_cost
label variable vil_subd_cost "Transportation cost from Village Office to Subdistrict Office in 000s Rp."

* Cleaning data

* Transportation from village office to neighboring subdistrict office
* Transport Mode
destring r1002c_k4, replace
rename r1002c_k4 vil_nsubd_mode //destring
label variable vil_nsubd_mode "Transport Mode from Village Office to Neighbouring Subdistrict Office"
replace vil_nsubd_mode=3 if vil_nsubd_mode>3
label define vil_nsubd_mode 1 "Public Transport" 2 "Private Vehicles" 3 "Others"
label values vil_nsubd_mode vil_nsubd_mode

* Distance (km)
rename r1002c_k2 vil_nsubd_dis
label variable vil_nsubd_dis "Distance from Village Office to Neighbouring Subdistrict Office"

* Travel Duration (hr)
gen vil_nsubd_dur=r1002c_k3
label variable vil_nsubd_dur "Travel duration from Village Office to Neighbouring Subdistrict Office"

* Tranport Cost
rename r1002c_k7 vil_nsubd_cost
label variable vil_nsubd_cost "Transportation cost from Village Office to Neighbouring Subdistrict Office in 000s Rp."

* Village Governance
* Government Domestic Income
rename r1501a_k3 inc_dom
destring r1501a_k2, replace
replace inc_dom=0 if r1501a_k2==4 

* Government VF Allocation
rename r1501b_k3 inc_vf
destring r1501b_k2, replace
replace inc_vf=0 if r1501b_k2==4

* Government Revenue Sharing / Grant
destring r1501c1_k2, replace
destring r1501c2_k2, replace
destring r1501c3_k2, replace
destring r1501c4_k2, replace
destring r1501c5_k2, replace
destring r1501c6_k2, replace
replace r1501c1_k3=0 if r1501c1_k2==4
replace r1501c2_k3=0 if r1501c2_k2==4
replace r1501c3_k3=0 if r1501c3_k2==4
replace r1501c4_k3=0 if r1501c4_k2==4
replace r1501c5_k3=0 if r1501c5_k2==4
replace r1501c6_k3=0 if r1501c6_k2==4
gen inc_rsg=r1501c1_k3+r1501c2_k3+r1501c3_k3+r1501c4_k3+r1501c5_k3+r1501c6_k3

label variable inc_dom "Revenue generated locally"
label variable inc_vf "Revenue from village fund transfer"
label variable inc_rsg "Revenue from other sources"


keep year village_id subd_id dist_id name_prov name_d name_subd name_vil id_prov id_d id_subd id_vil vil_type land_topo office_loc sea forest elec_pln elec_nonpln elec_na cook_fuel trans_river landfall_1 landfall_2 landfall_3 earthq_1 earthq_2 earthq_3 sch_el sch_jh sch_sh sch_uni pov_let vil_subd_mode vil_subd_dis vil_subd_dur vil_subd_cost vil_nsubd_mode vil_nsubd_dis vil_nsubd_dur vil_nsubd_cost inc_dom inc_vf inc_rsg

* Save processed data
save "./processed_data/podes14_processed.dta", replace


*********************************************************************************
* Structuring podes2011.dta														*
*********************************************************************************
clear

* Open .dta
use "./data/podes2011.dta"

* Preprocessing Data

* Year
gen year=2011

* Village_ID
destring iddesa, replace
rename iddesa village_id
label variable village_id "Village ID"

* Village, Subdistrict, District, Province Name
rename nama_prov name_prov
rename kode_prov id_prov
rename nama_kab name_d
rename kode_kab id_d
rename nama_kec name_subd
rename kode_kec id_subd
rename nama_desa name_vil
rename kode_desa id_vil
gen double subd_id=id_prov*100000+id_d*1000+id_subd
label variable subd_id "Subdistrict ID"
gen double dist_id=id_prov*100+id_d
label variable dist_id "District ID"

* Village Type
destring r301, replace
rename r301 vil_type
*drop if vil_type==3 | vil_type==4 // Drop Podes Transmigration Settlement Unit (UPT) or Transmigration Settlement Unit (SPT) observation
replace vil_type=0 if vil_type==2 | vil_type==3 | vil_type==4
label variable vil_type "=1 if village subsdistrict, =0 if urban subdistrict"

* Mainland Topography
destring r305a, replace
rename r305a land_topo
replace land_topo=0 if land_topo==4
replace land_topo=1 if land_topo==1 | land_topo==2 | land_topo==3
label variable land_topo "=1 if slope/valleys, =0 vast land"

* Village Government Office Location
destring r302b, replace
rename r302b office_loc
replace office_loc=0 if office_loc==2
replace office_loc=. if office_loc==3 // No office
label variable office_loc "=1 if inside region, =0 outside region"

* Village Bordering with Sea
destring r305d, replace
rename r305d sea
replace sea=0 if sea==2
label variable sea "=1 if border with sea, =0 no border with sea"

* Village Bordering with Forest
destring r306a, replace
rename r306a forest
replace forest=0 if forest==3
replace forest=1 if forest==1 | forest==2
label variable forest "=1 if inside or border with forest, =0 outside forest"

* Electricity 
rename r501a elec_pln
label variable elec_pln "Number of PLN electricity user household"
rename r501b elec_nonpln
label variable elec_nonpln "Number of Non-PLN electricity user household"
gen elec_na=.
label variable elec_na "Number of household without electricity"

* Cooking Fuel of Majority
destring r503, replace
rename r503 cook_fuel
label variable cook_fuel "Cooking Fuel Majority"
label define cook_fuel 1 "City gas" 2 "LPG" 3 "Kerosene" 4 "Firewood" 5 "Others"
label values cook_fuel cook_fuel

* River Transporation Use
destring r506b5k2, replace
rename r506b5k2 trans_river
replace trans_river=0 if trans_river==2
label variable trans_river "=1 if river used for transportation, =0 otherwise"

* Lake Transporation Use
* destring r506b5k4, replace
* rename r506b5k4 trans_lake
* replace trans_lake=0 if trans_lake==2
* label variable trans_lake "=1 if lake used for transportation, =0 otherwise"

* Natural Disaster
* Landfall Frequency
rename r60101k3 landfall
gen landfall_3=landfall/3
gen landfall_2=landfall/3
gen landfall_1=landfall/3
replace landfall_1=0 if missing(landfall_1)
replace landfall_2=0 if missing(landfall_2)
replace landfall_3=0 if missing(landfall_3)
label variable landfall_1 "Landfall frequency [y-1]"
label variable landfall_2 "Landfall frequency [y-2]"
label variable landfall_3 "Landfall frequency [y-3]"

* Earthquake Frequency
rename r60104k3 earth
gen earthq_3=earth/3
gen earthq_2=earth/3
gen earthq_1=earth/3
replace earthq_1=0 if missing(earthq_1)
replace earthq_2=0 if missing(earthq_2)
replace earthq_3=0 if missing(earthq_3)
label variable earthq_1 "Earthquake frequency [y-1]"
label variable earthq_2 "Earthquake frequency [y-2]"
label variable earthq_3 "Earthquake frequency [y-3]"

* Education and Health
* Elementary School
gen sch_el=r701bk2+r701bk3
label variable sch_el "Number of Elementary School"
* Junior High School
gen sch_jh=r701ck2+r701ck3 
label variable sch_jh "Number of Junior High School"
* Senior High School/ Vocational High School
gen sch_sh=r701dk2+r701dk3+r701ek2+r701ek3
label variable sch_sh "Number of Senior High School or Vocational High School"
* Higher Education
gen sch_uni=r701fk2+r701fk3 
label variable sch_uni "Number of University"

* Poverty, Number of Poverty Statement 2017
rename r712 pov_let
label variable pov_let "Number of poverty statement request"

* Transportation, Communication, and Information

* Transportation from village office to subdistrict office
* Transport Mode
gen vil_subd_mode=.
label variable vil_subd_mode "Transport Mode from Village Office to Subdistrict Office"
label define vil_subd_mode 1 "Public Transport" 2 "Private Vehicles" 3 "Others"
label values vil_subd_mode vil_subd_mode

* Distance (km)
rename r1004ak2 vil_subd_dis
label variable vil_subd_dis "Distance from Village Office to Subdistrict Office"

* Travel Duration (hr)
gen vil_subd_dur=.
label variable vil_subd_dur "Travel duration from Village Office to Subdistrict Office"

* Tranport Cost
gen vil_subd_cost=.
label variable vil_subd_cost "Transportation cost from Village Office to Subdistrict Office in 000s Rp."

* Cleaning data

* Transportation from village office to neighboring subdistrict office
* Transport Mode
gen vil_nsubd_mode=.
label variable vil_nsubd_mode "Transport Mode from Village Office to Neighbouring Subdistrict Office"
replace vil_nsubd_mode=3 if vil_nsubd_mode>3
label define vil_nsubd_mode 1 "Public Transport" 2 "Private Vehicles" 3 "Others"
label values vil_nsubd_mode vil_nsubd_mode

* Distance (km)
gen vil_nsubd_dis=.
label variable vil_nsubd_dis "Distance from Village Office to Neighbouring Subdistrict Office"

* Travel Duration (hr)
gen vil_nsubd_dur=.
label variable vil_nsubd_dur "Travel duration from Village Office to Neighbouring Subdistrict Office"

* Tranport Cost
gen vil_nsubd_cost=.
label variable vil_nsubd_cost "Transportation cost from Village Office to Neighbouring Subdistrict Office in 000s Rp."

* Village Governance
* Government Domestic Income
rename r1401ak3 inc_dom
destring r1401ak2, replace
replace inc_dom=0 if r1401ak2==4 

* Government VF Allocation
gen inc_vf=.

* Government Revenue Sharing / Grant
destring r1401b1k2, replace
destring r1401b2k2, replace
destring r1401b3k2, replace
destring r1401b4k2, replace
destring r1401b5k2, replace
destring r1401b6k2, replace
replace r1401b1k3=0 if r1401b1k2==4
replace r1401b2k3=0 if r1401b2k2==4
replace r1401b3k3=0 if r1401b3k2==4
replace r1401b4k3=0 if r1401b4k2==4
replace r1401b5k3=0 if r1401b5k2==4
replace r1401b6k3=0 if r1401b6k2==4
gen inc_rsg=r1401b1k3+r1401b2k3+r1401b3k3+r1401b4k3+r1401b5k3+r1401b6k3

label variable inc_dom "Revenue generated locally"
label variable inc_vf "Revenue from village fund transfer"
label variable inc_rsg "Revenue from other sources"


keep year village_id subd_id dist_id name_prov name_d name_subd name_vil id_prov id_d id_subd id_vil vil_type land_topo office_loc sea forest elec_pln elec_nonpln elec_na cook_fuel trans_river landfall_1 landfall_2 landfall_3 earthq_1 earthq_2 earthq_3 sch_el sch_jh sch_sh sch_uni pov_let vil_subd_mode vil_subd_dis vil_subd_dur vil_subd_cost vil_nsubd_mode vil_nsubd_dis vil_nsubd_dur vil_nsubd_cost inc_dom inc_vf inc_rsg


* Save processed data
save "./processed_data/podes11_processed.dta", replace

*********************************************************************************
* Combine all data																*
*********************************************************************************
* Append data
append using "./processed_data/podes17_processed.dta"

append using "./processed_data/podes14_processed.dta"

* Merge IDM Status from Kemendes
merge m:1 village_id using "./processed_data/kemendes_novf.dta"
drop _merge

* Save processed data
save "./processed_data/podes_processed.dta", replace


* Erase temporary files
erase "./processed_data/podes17_processed.dta"

erase "./processed_data/podes14_processed.dta"

erase "./processed_data/podes11_processed.dta"

*********************************************************************************
* Generate year dummy															*
*********************************************************************************
gen y11=0
replace y11=1 if year==2011
gen y14=0
replace y14=1 if year==2014
gen y18=0
replace y18=1 if year==2018

*********************************************************************************
* Create Unit Cost Variable														*
*********************************************************************************

xtset village_id year
gen unit_cost=vil_subd_cost/vil_subd_dis
replace trans_river=0 if missing(trans_river)

save "./processed_data/podes_processed.dta", replace

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
gen subd_prog = 0
replace subd_prog =1 if count1>0
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

*********************************************************************************
* Save processed data 2014, 2018												*
*********************************************************************************

preserve

sort village_id year
drop if year == 2011
egen count = count(village_id), by(village_id)
drop if count == 1
drop count

save "./processed_data/podes_processed.dta", replace


*********************************************************************************
* Save raw clean data															*
*********************************************************************************
restore
save "./processed_data/podes_raw.dta", replace
