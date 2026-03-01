---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 3
section_title: Vaidya's cutting plane method
subsection: null
subsection_title: null
section_id: '2.3'
tex_label: ''
theorems: []
lean_files: []
---

\section{Vaidya's cutting plane method}
We focus here on the feasibility problem (it should be clear from the previous sections how to adapt the argument for optimization). We have seen that for the feasibility problem the center of gravity has a $O(n)$ oracle complexity and unclear computational complexity (see Section \ref{sec:rwmethod} for more on this), while the ellipsoid method has oracle complexity $O(n^2)$ and computational complexity $O(n^4)$. We describe here the beautiful algorithm of \cite{Vai89, Vai96} which has oracle complexity $O(n \log(n))$ and computational complexity $O(n^4)$, thus getting the best of both the center of gravity and the ellipsoid method. In fact the computational complexity can even be improved further, and the recent breakthrough \cite{LSW15} shows that it can essentially (up to logarithmic factors) be brought down to $O(n^3)$.

This section, while giving a fundamental algorithm, should probably be skipped on a first reading. In particular we use several concepts from the theory of interior point methods which are described in Section \ref{sec:IPM}.