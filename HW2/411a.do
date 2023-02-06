texdoc init example1.tex, replace

/*** 
\documentclass[a4paper]{article}
\usepackage{stata}
\begin{document}

\section*{Some options of texdoc stlog}
\begin{itemize}
\item Default: input (commands) and output
***/

texdoc stlog
display "2 + 2 = " 2 + 2
display "sqrt(2) = " /// this is a comment
    sqrt(2)
texdoc stlog close

/*** \item \stcmd{cmdstrip}: output without input ***/

texdoc stlog, cmdstrip
display "2 + 2 = " 2 + 2
display "sqrt(2) = " /// this is a comment
    sqrt(2)
texdoc stlog close

/*** \item \stcmd{nooutput}: input without output ***/

texdoc stlog, nooutput
display "2 + 2 = " 2 + 2
display "sqrt(2) = " /// this is a comment
    sqrt(2)
texdoc stlog close

/*** \item \stcmd{lbstrip}/\stcmd{gtstrip}: remove 
     line-break comments and continuation symbols ***/

texdoc stlog, lbstrip gtstrip
display "2 + 2 = " 2 + 2
display "sqrt(2) = " /// this is a comment
    sqrt(2)
texdoc stlog close

/*** \item \stcmd{matastrip}: remove Mata begin and end commands ***/
texdoc stlog, matastrip
mata:
2 + 2
sqrt(2)
end
texdoc stlog close

/*** Without \stcmd{matastrip} the result would look as follows: ***/

texdoc stlog
mata:
2 + 2
sqrt(2)
end
texdoc stlog close

/***
\end{itemize}
\end{document}
***/