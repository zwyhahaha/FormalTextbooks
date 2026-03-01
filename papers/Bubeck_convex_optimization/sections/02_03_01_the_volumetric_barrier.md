---
book: Bubeck_convex_optimization
chapter: 2
chapter_title: Convex optimization in finite dimension
section: 3
section_title: Vaidya's cutting plane method
subsection: 1
subsection_title: The volumetric barrier
section_id: 2.3.1
tex_label: ''
theorems: []
lean_files: []
---

\subsection{The volumetric barrier}
Let $A \in \mathbb{R}^{m \times n}$ where the $i^{th}$ row is $a_i \in \mathbb{R}^n$, and let $b \in \mathbb{R}^m$. We consider the logarithmic barrier $F$ for the polytope $\{x \in \mathbb{R}^n : A x > b\}$ defined by
$$F(x) = - \sum_{i=1}^m \log(a_i^{\top} x - b_i) .$$
We also consider the volumetric barrier $v$ defined by
$$v(x) = \frac{1}{2} \mathrm{logdet}(\nabla^2 F(x) ) .$$
The intuition is clear: $v(x)$ is equal to the logarithm of the inverse volume of the Dikin ellipsoid (for the logarithmic barrier) at $x$. It will be useful to spell out the hessian of the logarithmic barrier:
$$\nabla^2 F(x) = \sum_{i=1}^m \frac{a_i a_i^{\top}}{(a_i^{\top} x - b_i)^2} .$$
Introducing the leverage score
$$\sigma_i(x) = \frac{(\nabla^2 F(x) )^{-1}[a_i, a_i]}{(a_i^{\top} x - b_i)^2} ,$$
one can easily verify that
 \label{eq:gradvol}
\nabla v(x) = - \sum_{i=1}^m \sigma_i(x) \frac{a_i}{a_i^{\top} x - b_i} ,

and 

 \label{eq:hessianvol}
\nabla^2 v(x) \succeq \sum_{i=1}^m \sigma_i(x) \frac{a_i a_i^{\top}}{(a_i^{\top} x - b_i)^2} =: Q(x) .