/*
Filename: HW3.do
Project	: Homework 3
Course	: ECON 7023, Spring 2023
Name	: Maghfira Ramadhani
*/

clear

*Problem 5.4
cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II"
use ".\data\card.dta"

*5.4a
texdoc do ".\HW3\54a.texdoc"

est clear
eststo: reg lwage educ exper expersq black south smsa reg661-reg668 smsa66
esttab using ".\HW3\reg54a.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 5.4.a.")   ///
 addnotes("Data: CARD.DTA" "Wooldridge (2011)")

*5.4b,d
est clear
eststo: reg educ exper expersq black south smsa reg661-reg668 smsa66 nearc4
eststo: reg educ exper expersq black south smsa reg661-reg668 smsa66 nearc4 nearc2
esttab using ".\HW3\reg54b.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression results for (1) Problem 5.4.b. and (2) Problem 5.4.d")   ///
 addnotes("Data: CARD.DTA" "Wooldridge (2011)")

 
*5.4cd
texdoc do ".\HW3\54c.texdoc"

est clear
eststo: ivreg lwage exper expersq black south smsa reg661-reg668 smsa66 (educ = nearc4)
eststo: ivreg lwage exper expersq black south smsa reg661-reg668 smsa66 (educ = nearc4 nearc2)
esttab using ".\HW3\reg54c.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression results for (1) Problem 5.4.c. and (2) Problem 5.4.d.")   ///
 addnotes("Data: CARD.DTA" "Wooldridge (2011)")

*5.4e
est clear
eststo: reg iq nearc4
eststo: reg iq nearc4 smsa66 reg661 reg662 reg669
esttab using ".\HW3\reg54e.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression results for (1) Problem 5.4.e. and (2) Problem 5.4.f.")   ///
 addnotes("Data: CARD.DTA" "Wooldridge (2011)")

clear

*5.7c
use ".\data\nls80.dta"
texdoc do ".\HW3\57c.texdoc"

est clear
eststo: ivreg lwage tenure educ married south urban black (iq = meduc feduc sibs)
eststo: ivreg lwage tenure educ married south urban black (kww = meduc feduc sibs)
esttab using ".\HW3\reg57c.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression results for Problem 5.7.c.")   ///
 addnotes("Data: NLS80.DTA" "Wooldridge (2011)")

clear

*Problem 6.7
use ".\data\hprice.dta"
 
*6.7a
est clear
eststo: reg lprice ldist if y81
esttab using ".\HW3\reg67a.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 6.7.a.")   ///
 addnotes("Data: HPRICE.DTA" "Wooldridge (2011)")

  
*6.7b,c
gen y81ldist = y81*ldist
label variable y81ldist "y81 x log(dist)"
est clear
eststo: reg lprice y81 ldist y81ldist
eststo: reg lprice y81 ldist y81ldist lintst lintstsq larea lland age agesq rooms baths
esttab using ".\HW3\reg67b.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression results: (1) Problem 6.7.b. and (2) 6.7.c")   ///
 addnotes("Data: HPRICE.DTA" "Wooldridge (2011)") 
 
clear
