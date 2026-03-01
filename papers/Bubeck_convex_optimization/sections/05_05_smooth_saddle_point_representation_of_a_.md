---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 5
section_title: Smooth saddle-point representation of a non-smooth function
subsection: null
subsection_title: null
section_id: '5.5'
tex_label: sec:sprepresentation
theorems: []
lean_files: []
---

\section{Smooth saddle-point representation of a non-smooth function} \label{sec:sprepresentation}
Quite often the non-smoothness of a function $f$ comes from a $\max$ operation. More precisely non-smooth functions can often be represented as
 \label{eq:sprepresentation}
f(x) = \max_{1 \leq i \leq m} f_i(x) ,

where the functions $f_i$ are smooth. This was the case for instance with the function we used to prove the black-box lower bound $1/\sqrt{t}$ for non-smooth optimization in Theorem \ref{th:lb1}. We will see now that by using this structural representation one can in fact attain a rate of $1/t$. This was first observed in \cite{Nes04b} who proposed the Nesterov's smoothing technique. Here we will present the alternative method of \cite{Nem04} which we find more transparent (yet another version is the Chambolle-Pock algorithm, see \cite{CP11}). Most of what is described in this section can be found in \cite{JN11a, JN11b}.

In the next subsection we introduce the more general problem of saddle point computation. We then proceed to apply a modified version of mirror descent to this problem, which will be useful both in Chapter \ref{rand} and also as a warm-up for the more powerful modified mirror prox that we introduce next.