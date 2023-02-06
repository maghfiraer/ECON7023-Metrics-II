/*
Project	: Homework 2
Course	: ECON 7023, Spring 2023
Name	: Maghfira Ramadhani
*/

*Problem 4.11
cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II"
use ".\data\nls80.dta"

texdoc do ".\HW2\411a.do"

est clear
eststo: reg lwage exper tenure married south urban black educ iq kww
eststo: reg lwage exper tenure married south urban black educ iq
esttab using ".\HW2\reg411a.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for Problem 4.11.a. \label{reg1}")   ///
 addnotes("Data: NLS80.DTA" "Wooldridge (2011)")