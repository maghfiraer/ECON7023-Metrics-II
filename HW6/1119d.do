texdoc init "./HW6/1119d.tex", replace

/***
Create Interaction Terms
***/
texdoc stlog
egen avg_ldist=mean(ldist)
gen dmldist=ldist - avg_ldist
egen avg_ldistsq=mean(ldistsq)
gen dmldistsq=ldistsq - avg_ldistsq
gen ldistxlfare=dmldist*lfare
gen ldistsqxlfare=dmldistsq*lfare
gen ldistxconcen=dmldist*concen
gen ldistsqxconcen=dmldistsq*concen
texdoc stlog close
/***
RE IV Estimate
***/
texdoc stlog
xtivreg lpassen ldist ldistsq y98 y99 y00 (lfare ldistxlfare ldistsqxlfare= ///
concen ldistxconcen ldistsqxconcen), re
texdoc stlog close
/***
FE IV Estimate
***/
texdoc stlog
xtivreg lpassen y98 y99 y00 (lfare ldistxlfare ldistsqxlfare= ///
concen ldistxconcen ldistsqxconcen), re
texdoc stlog close
