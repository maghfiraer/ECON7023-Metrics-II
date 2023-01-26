/*
Project	: Homework 1
Course	: ECON 7023, Spring 2023
Name	: Maghfira Ramadhani
*/


cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II"
use ".\data\nls80.dta"

est clear
eststo: reg lwage exper tenure married south urban black educ, robust
esttab using ".\HW1\reg1.tex", replace ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs ///
 title("Regression result for \eqref{h1.0} \label{reg1}")   ///
 addnotes("Data: NLS80.DTA" "Wooldridge (2011)")