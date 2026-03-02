---
book: Bubeck_convex_optimization
chapter: 1
chapter_title: Introduction
section: 0
section_title: Introduction
subsection: null
subsection_title: null
section_id: '1.0'
tex_label: ''
theorems:
- id: Definition 1.1
  label: Convex sets and convex functions
  tex_label: ''
lean_files:
- id: Definition 1.1
  path: proofs/Bubeck_convex_optimization/Definition11.lean
  status: proved

---

The central objects of our study are convex functions and convex sets in $\R^n$.

**Definition** (Convex sets and convex functions)

A set $\cX \subset \R^n$ is said to be convex if it contains all of its segments, that is
$$\forall (x,y,\gamma) \in \cX \times \cX \times [0,1], \; (1-\gamma) x + \gamma y \in \mathcal{X}.$$
A function $f : \mathcal{X} \rightarrow \R$ is said to be convex if it always lies below its chords, that is
$$ \forall (x,y,\gamma) \in \cX \times \cX \times [0,1], \; f((1-\gamma) x + \gamma y) \leq (1-\gamma)f(x) + \gamma f(y) .$$

We are interested in algorithms that take as input a convex set $\cX$ and a convex function $f$ and output an approximate minimum of $f$ over $\cX$. We write compactly the problem of finding the minimum of $f$ over $\cX$ as
\begin{align*}
& \mathrm{min.} \; f(x) \\
& \text{s.t.} \; x \in \cX .
\end{align*}
In the following we will make more precise how the set of constraints $\cX$ and the objective function $f$ are specified to the algorithm. Before that we proceed to give a few important examples of convex optimization problems in machine learning.