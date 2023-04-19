texdoc init "./HW6/1119a.tex", replace

/***
RE estimate
***/
texdoc stlog
xtreg lfare concen ldist ldistsq y98 y99 y00, re cluster(id)
texdoc stlog close
/***
FE estimate
***/
texdoc stlog
xtreg lfare concen y98 y99 y00, fe cluster(id)
texdoc stlog close
