/*
Project	: Homework 2
Course	: ECON 7023, Spring 2023
Name	: Maghfira Ramadhani
*/

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
 title("Regression result for Problem 4.11.a. \label{reg1}")   ///
 addnotes("Data: NLS80.DTA" "Wooldridge (2011)")

*4.11b
texdoc do ".\HW2\411b.texdoc"

*4.11d
texdoc do ".\HW2\411d.texdoc"