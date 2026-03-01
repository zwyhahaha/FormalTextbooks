---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 7
section_title: Nesterov's accelerated gradient descent
subsection: null
subsection_title: null
section_id: '3.7'
tex_label: sec:AGD
theorems: []
lean_files: []
---

\section{Nesterov's accelerated gradient descent} \label{sec:AGD}

We describe here the original Nesterov's method which attains the optimal oracle complexity for smooth convex optimization. We give the details of the method both for the strongly convex and non-strongly convex case. We refer to \cite{SBC14} for a recent interpretation of the method in terms of differential equations, and to \cite{AO14} for its relation to mirror descent (see Chapter \ref{mirror}).