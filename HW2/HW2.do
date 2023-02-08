/*
Filename: HW2.do
Project	: Homework 2
Course	: ECON 7023, Spring 2023
Name	: Maghfira Ramadhani
*/

clear

*Problem 4.11
cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II"
use ".\data\nls80.dta"

*4.11a
texdoc do ".\HW2\411a.texdoc"

est clear
eststo: reg lwage exper tenure married south urban black educ iq kww
eststo: reg lwage exper tenure married south urban black educ iq
eststo: reg lwage exper tenure married south urban black educ
esttab using ".\HW2\reg411a.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 4.11.a.")   ///
 addnotes("Data: NLS80.DTA" "Wooldridge (2011)")

*4.11b
texdoc do ".\HW2\411b.texdoc"

*4.11d
texdoc do ".\HW2\411d.texdoc"
est clear
eststo: reg lwage exper tenure married south urban black educ iq kww educiq educkww
esttab using ".\HW2\reg411d.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 4.11.d.")   ///
 addnotes("Data: NLS80.DTA" "Wooldridge (2011)")
 
clear
 
*Problem 4.13
use ".\data\cornwell.dta"
 
*4.13a,b
xtset county year
gen lcrmrte1=L1.lcrmrte
label variable lcrmrte1 "log(crmrte)[t-1]"
est clear
eststo: reg lcrmrte lprbarr lprbconv lprbpris lavgsen if d87
eststo: reg lcrmrte lprbarr lprbconv lprbpris lavgsen lcrmrte1 if d87
esttab using ".\HW2\reg413ab.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 4.13.a and 4.13.b.")   ///
 addnotes("Data: CORNWELL.DTA" "Cornwell and Trumball (1994)")
 
*4.13c
texdoc do ".\HW2\413c.texdoc"
 
*4.13d
texdoc do ".\HW2\413d.texdoc"
 
clear
 
*Problem 4.14
use ".\data\attend.dta"

*4.14a,c,e,f
gen priGPAsq = priGPA^2
label variable priGPAsq "priGPA^2"
gen ACTsq = ACT^2
label variable ACTsq "ACT^2"
gen atndrtesq = atndrte^2
label variable atndrtesq "atndrte^2"
est clear
eststo: reg stndfnl atndrte frosh soph
eststo: reg stndfnl atndrte frosh soph priGPA ACT
eststo: reg stndfnl atndrte frosh soph priGPA ACT priGPAsq ACTsq
eststo: reg stndfnl atndrte frosh soph priGPA ACT priGPAsq ACTsq atndrtesq
esttab using ".\HW2\reg414acef.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 4.14.a., 4.14.c, 4.14.e, and 4.14.f")   ///
 addnotes("Data: ATTEND.DTA" "Wooldridge (2011)")

texdoc do ".\HW2\414e.texdoc"

est clear
estpost correlate atndrte atndrtesq, matrix listwise
esttab using ".\HW2\414f.tex", replace ///
 unstack not noobs compress b(2) label ///
 booktabs ///
 title("Regression result for Problem 4.14.a., 4.14.c, 4.14.e, and 4.14.f")   ///
 addnotes("Data: ATTEND.DTA" "Wooldridge (2011)")
clear

*Problem 5.3
*5.3c
use ".\data\bwght.dta"
texdoc do  ".\HW2\53c.texdoc"

*5.3d
texdoc do  ".\HW2\53d.texdoc"