texdoc init "./HW6/1115b.tex", replace

/***
Simple Regresison
***/
texdoc stlog
reg chrsemp cgrant if d88
texdoc stlog close
/***
Exluding missing value
***/
texdoc stlog
reg chrsemp cgrant if d88 & clscrap~=.
texdoc stlog close
