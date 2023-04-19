texdoc init "./HW6/1119f.tex", replace

/***
Calculate elasticity at dist=500, and 1500
***/
sum ldist if y00
display log(500)-r(mean)
display log(1500)-r(mean)
sum ldistsq if y00
display (log(500))^2-r(mean)
display (log(1500))^2-r(mean)
lincom lfare-.48187347*ldistxlfare-6.6561169*ldistsqxlfare
lincom lfare+.61673882*ldistxlfare+8.2057217*ldistsqxlfare
