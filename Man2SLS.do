// Code Title	: Manual 2 SLS Estimation
// Author		: Maghfira Ramadhani
// Reference	: 
// 					- Stata Forum :			https://www.statalist.org/forums/forum/general-stata-discussion/general/1629151-correcting-standard-errors-in-iv-procedure-carried-out-manually
// 					- ivreg Manuals, Methods: https://www.stata.com/manuals/rivregress.pdf
// Data			: NLS80.DTA from Wooldridge textbook

// Option robust
clear 
cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II"
use ".\data\nls80.dta"
// First Stage
regress iq exper tenure educ married south urban black meduc feduc sibs, r
predict double iqhat
// Second Stage
regress lwage iqhat exper tenure educ married south urban black, mse1
rename iqhat iqhold
rename iq iqhat
predict double res if e(sample), residual
rename iqhat iq
rename iqhold iqhat
replace res = res^2
summarize res
matrix Vmatrix = e(V)
mat accum u2xx = iqhat exper tenure educ married south urban black [iw = res]
matrix bmatrix = e(b)
matrix Vmatrix = Vmatrix*u2xx*Vmatrix
ereturn post bmatrix Vmatrix, noclear
ereturn display
// 2SLS
ivregress 2sls lwage exper tenure educ married south urban black (iq = meduc feduc sibs), robust

// Option no robust
clear 
cd "C:\Users\mramadhani3\OneDrive - Georgia Institute of Technology\Documents\Spring 23\Metrics II ECON7023\ECON7023-Metrics-II"
use ".\data\nls80.dta"
// First Stage
regress iq exper tenure educ married south urban black meduc feduc sibs
predict double iqhat
// Second Stage
regress lwage iqhat exper tenure educ married south urban black
rename iqhat iqhold
rename iq iqhat
predict double res if e(sample), residual 
rename iqhat iq
rename iqhold iqhat
replace res = res^2
summarize res
// If want to adjust for degree of freedom
//scalar realmse = r(mean)*r(N)/e(df_r) 
// If not
scalar realmse = r(mean) 
matrix bmatrix = e(b)
matrix Vmatrix = e(V)
matrix Vmatrix = e(V) * realmse / e(rmse)^2
ereturn post bmatrix Vmatrix, noclear
ereturn display
// 2SLS
// If want to adjust for degree of freedom
//ivregress 2sls lwage exper tenure educ married south urban black (iq = meduc feduc sibs), small
// If not
ivregress 2sls lwage exper tenure educ married south urban black (iq = meduc feduc sibs)
