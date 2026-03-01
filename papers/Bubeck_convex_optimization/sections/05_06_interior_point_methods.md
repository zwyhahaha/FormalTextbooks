---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 6
section_title: Interior point methods
subsection: null
subsection_title: null
section_id: '5.6'
tex_label: sec:IPM
theorems: []
lean_files: []
---

\section{Interior point methods} \label{sec:IPM}
We describe here interior point methods (IPM), a class of algorithms fundamentally different from what we have seen so far. The first algorithm of this type was described in \cite{Kar84}, but the theory we shall present was developed in \cite{NN94}. We follow closely the presentation given in [Chapter 4, \cite{Nes04}]. Other useful references (in particular for the primal-dual IPM, which are the ones used in practice) include \cite{Ren01, Nem04b, NW06}.
\newline

IPM are designed to solve convex optimization problems of the form
\begin{align*}
& \mathrm{min.} \; c^{\top} x \\
& \text{s.t.} \; x \in \cX ,
\end{align*}
with $c \in \R^n$, and $\cX \subset \R^n$ convex and compact. 

Note that, at this point, the linearity of the objective is without loss of generality as minimizing a convex function $f$ over $\cX$ is equivalent to minimizing a linear objective over the epigraph of $f$ (which is also a convex set). The structural assumption on $\cX$ that one makes in IPM is that there exists a {\em self-concordant barrier} for $\cX$ with an easily computable gradient and Hessian. The meaning of the previous sentence will be made precise in the next subsections. The importance of IPM stems from the fact that LPs and SDPs (see Section \ref{sec:structured}) satisfy this structural assumption.