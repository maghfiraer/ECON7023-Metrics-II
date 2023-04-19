texdoc init "./HW6/1115c.tex", replace

/***
IV estimate
***/
texdoc stlog
ivreg clscrap (chrsemp = cgrant) if d88
texdoc stlog close

