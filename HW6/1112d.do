texdoc init "./HW6/1112d.tex", replace

/***
Estimates if Texas is dropped out
OLS
***/
texdoc stlog
reg cmrdrte cexec cunem if (d93==1 & state!="TX")
texdoc stlog close
/***
IV Estimates
***/
texdoc stlog
reg cmrdrte cexec cunem (cexec_1 cunem) if (d93==1 & state!="TX")
texdoc stlog close
