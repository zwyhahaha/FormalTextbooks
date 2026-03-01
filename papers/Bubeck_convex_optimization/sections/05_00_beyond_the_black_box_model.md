---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 0
section_title: Beyond the black-box model
subsection: null
subsection_title: null
section_id: '5.0'
tex_label: ''
theorems: []
lean_files: []
---

In the black-box model non-smoothness dramatically deteriorates the rate of convergence of first order methods from $1/t^2$ to $1/\sqrt{t}$. However, as we already pointed out in Section \ref{sec:structured}, we (almost) always know the function to be optimized {\em globally}. In particular the ``source" of non-smoothness can often be identified. For instance the LASSO objective (see Section \ref{sec:mlapps}) is non-smooth, but it is a sum of a smooth part (the least squares fit) and a {\em simple} non-smooth part (the $\ell_1$-norm). Using this specific structure we will propose in Section \ref{sec:simplenonsmooth} a first order method with a $1/t^2$ convergence rate, despite the non-smoothness. In Section \ref{sec:sprepresentation} we consider another type of non-smoothness that can effectively be overcome, where the function is the maximum of smooth functions. Finally we conclude this chapter with a concise description of interior point methods, for which the structural assumption is made on the constraint set rather than on the objective function.