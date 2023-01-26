$--------------------------------HW 1
$
$
$


cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023"
use ".\data\nls80.dta"

eststo: reg lwage exper tenure married south urban black educ, robust
esttab using ".\HW1\reg1.tex", replace
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01)
 booktabs
 title("Basic regression table \label{reg1}")   ///
 addnotes("Data: websuse nlswork" "Second line note")