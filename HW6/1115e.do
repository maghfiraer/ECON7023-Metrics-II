texdoc init "./HW6/1115e.tex", replace

/***
IV estimate
***/
texdoc stlog
ivreg clscrap d89 (chrsemp = cgrant)
texdoc stlog close

