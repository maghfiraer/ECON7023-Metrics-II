texdoc init "./HW6/1112c.tex", replace

/***
Testing Rank Condition
***/
texdoc stlog
reg cmrdrte cexec_1 cunem if d93
texdoc stlog close
/***
IV Estimates
***/
texdoc stlog
reg cmrdrte cexec cunem (cexec_1 cunem) if d93
texdoc stlog close
