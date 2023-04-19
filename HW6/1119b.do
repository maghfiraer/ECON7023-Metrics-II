texdoc init "./HW6/1119b.tex", replace

/***
RE estimate
***/
texdoc stlog
xtivreg lpassen y98 y99 y00 (lfare = concen), re
texdoc stlog close
/***
RE estimate+Control
***/
texdoc stlog
xtivreg lpassen ldist ldistsq y98 y99 y00 (lfare = concen), re
texdoc stlog close
