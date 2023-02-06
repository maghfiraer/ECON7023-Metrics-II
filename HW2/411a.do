/*
Project	: Homework 2
Course	: ECON 7023, Spring 2023
Name	: Maghfira Ramadhani
*/

texdoc init ".\HW2\output411a.tex", replace
/***
\begin{document}
*///
texdoc stlog
reg lwage exper tenure married south urban black educ iq kww
reg lwage exper tenure married south urban black educ iq
texdoc stlog close
/***
\end{document}
*///