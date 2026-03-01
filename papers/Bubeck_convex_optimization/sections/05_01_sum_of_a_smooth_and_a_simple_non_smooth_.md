---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 1
section_title: Sum of a smooth and a simple non-smooth term
subsection: null
subsection_title: null
section_id: '5.1'
tex_label: sec:simplenonsmooth
theorems: []
lean_files: []
---

\section{Sum of a smooth and a simple non-smooth term} \label{sec:simplenonsmooth}
We consider here the following problem.}:
$$\min_{x \in \R^n} f(x) + g(x) ,$$
where $f$ is convex and $\beta$-smooth, and $g$ is convex. We assume that $f$ can be accessed through a first order oracle, and that $g$ is known and ``simple". What we mean by simplicity will be clear from the description of the algorithm. For instance a separable function, that is $g(x) = \sum_{i=1}^n g_i(x(i))$, will be considered as simple. The prime example being $g(x) = \|x\|_1$. This section is inspired from \cite{BT09} (see also \cite{Nes07, WNF09}).