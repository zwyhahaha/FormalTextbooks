---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 0
section_title: Convex optimization in finite dimension
subsection: null
subsection_title: null
section_id: '2.0'
tex_label: ''
theorems: []
lean_files: []
---

Let $\mathcal{X} \subset \R^n$ be a convex body (that is a compact convex set with non-empty interior), and $f : \mathcal{X} \rightarrow [-B,B]$ be a continuous and convex function. Let $r, R>0$ be such that $\mathcal{X}$ is contained in an Euclidean ball of radius $R$ (respectively it contains an Euclidean ball of radius $r$). In this chapter we give several black-box algorithms to solve 
\begin{align*}
& \mathrm{min.} \; f(x) \\
& \text{s.t.} \; x \in \cX .
\end{align*}
As we will see these algorithms have an oracle complexity which is linear (or quadratic) in the dimension, hence the title of the chapter (in the next chapter the oracle complexity will be {\em independent} of the dimension). An interesting feature of the methods discussed here is that they only need a separation oracle for the constraint set $\cX$. In the literature such algorithms are often referred to as {\em cutting plane methods}. In particular these methods can be used to {\em find} a point $x \in \cX$ given only a separating oracle for $\cX$ (this is also known as the {\em feasibility problem}).