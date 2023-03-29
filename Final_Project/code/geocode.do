*********************************************************************************
* AUTHOR		: MAGHFIRA RAMADHANI											*
* PROJECT		: MEASURING VILLAGE INFRASTRUCTURE DEVELOPMENT IN INDONESIA		*
* COURSE		: ECON 7023 Econometrics II										*
* DESCRIPTION	: Geocode and Graphing											*
* INPUT			: ESRI shapefile 												*
* OUTPUT		: /figures, /table												*
* STATA VERSION	: Stata/MP 17.0 (March 2022)									*
*********************************************************************************

*********************************************************************************
* Transport Cost Map															*
*********************************************************************************
clear
use "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\processed_data\podes_processed.dta"

keep if year==2018
keep year village_id name_vil vil_subd_cost /// Can add other variable

*** Data cleaning
drop if vil_subd_cost==0 | vil_subd_cost>9000

save "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\processed_data\podes_tmp.dta", replace

*The following package must be installed
*ssc install spmap    // for the maps package
*ssc install shp2dta  // shapefiles to dta. For versions < v15.
*ssc install geo2xy   // for fixing the coordinate system
*ssc install palettes, replace    // for color palettes
*ssc install colrspace, replace   // for expanding the color base

********* get the shapefiles in order in order
cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\GIS\bps"    // switch to the GIS folder
spshape2dta "idn_bnd_adm4_2017_bps_a.shp", replace saving(id_vil)

*** explore the outline file
use id_vil_shp, clear
*scatter _Y _X, msize(tiny) msymbol(point)

*** merge with attributes file to get the names
merge m:1 _ID using id_vil
drop rec_header- _merge    // drop all additional variables
*scatter _Y _X, msize(tiny) msymbol(point)

sort _ID
save, replace

*** generate a file for labels
use id_vil, clear  
 ren A4N_BPS name_vil
 keep _CX _CY name_vil
 geo2xy _CY _CX, proj(web_mercator) replace  // fix the projection
 compress
 save id_vil_label.dta, replace
 
use id_vil, clear
 ren A4C_BPS village_id
*** the first map
*spmap using id_vil_shp, id(_ID)

merge 1:m village_id using "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\processed_data\podes_tmp.dta"
tab name_vil if _m==1  // show the unmerged countries in world.dta
tab name_vil if _m==2 // show the unmerged countries in COVID data
*** see exactly how many countries merged
egen tag = tag(name_vil)  // tag=1 for each country observation
tab _m if tag==1         // 178 countries merge perfectly.

drop if _m==2   // drop the unmerged countries from the policy data


*********************************************************************************
* Transport Cost Map															*
*********************************************************************************
*** generate a local for the w3 color scheme
colorpalette DarkGoldenRod Green Red, n(10)  nograph
local colors `r(p)'

summ year
spmap vil_subd_cost using id_vil_shp, ///
	id(_ID) ///
	clmethod(custom) clbreaks(0(10)100)    ///
	ocolor(black ..) fcolor("`colors'") osize(0.001 ..)  ///
	ndocolor(black ..) ndfcolor(black ..) ndsize(0.01 ..) ndlabel("Missing") ///
	legend(pos(7) size(*0.8)) legstyle(2) /// 
	title("Transportation Cost", size(medium)) ///
	note("Data source: Village Potential Statistics." , size(tiny))
graph export "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II\Final_Project\output\figure\Transcost.png", as(png) name("Graph") replace

*********************************************************************************
* Other Graph																	*
*********************************************************************************

