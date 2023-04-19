texdoc init "./HW6/1119e.tex", replace

/***
Robust FE IV Estimate using 
***/
texdoc stlog
xtivreg2 lpassen y98 y99 y00 (lfare ldistxlfare ldistsqxlfare= ///
concen ldistxconcen ldistsqxconcen), fe cluster(id)
texdoc stlog close
/***
Test of Joint Significance
***/
texdoc stlog
test ldistxlfare ldistsqxlfare
texdoc stlog close
