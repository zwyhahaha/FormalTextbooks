---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 4
section_title: CMD and RDA
subsection: null
subsection_title: null
section_id: '5.4'
tex_label: ''
theorems: []
lean_files: []
---

\section*{CMD and RDA}
ISTA and FISTA assume smoothness in the Euclidean metric. Quite naturally one can also use these ideas in a non-Euclidean setting. Starting from \eqref{eq:MDproxview} one obtains the CMD (Composite Mirror Descent) algorithm of \cite{DSSST10}, while with \eqref{eq:DA0} one obtains the RDA (Regularized Dual Averaging) of \cite{Xia10}. We refer to these papers for more details.