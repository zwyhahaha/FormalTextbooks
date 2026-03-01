---
book: Bubeck_convex_optimization
chapter: 1
chapter_title: Introduction
section: 3
section_title: Why convexity?
subsection: null
subsection_title: null
section_id: '1.3'
tex_label: ''
theorems:
- id: Proposition 1.5
  label: Local minima are global minima
  tex_label: ''
- id: Proposition 1.6
  label: First order optimality condition
  tex_label: prop:firstorder
lean_files:
- id: Proposition 1.5
  path: proofs/Bubeck_convex_optimization/Proposition15.lean
  status: pending
- id: Proposition 1.6
  path: proofs/Bubeck_convex_optimization/Proposition16.lean
  status: pending
---

\section{Why convexity?}
The key to the algorithmic success in minimizing convex functions is that these functions exhibit a {\em local to global} phenomenon. We have already seen one instance of this in Proposition \ref{prop:existencesubgradients}, where we showed that $\nabla f(x) \in \partial f(x)$: the gradient $\nabla f(x)$ contains a priori only local information about the function $f$ around $x$ while the subdifferential $\partial f(x)$ gives a global information in the form of a linear lower bound on the entire function. Another instance of this local to global phenomenon is that local minima of convex functions are in fact global minima:

**Proposition** (Local minima are global minima)

Let $f$ be convex. If $x$ is a local minimum of $f$ then $x$ is a global minimum of $f$. Furthermore this happens if and only if $0 \in \partial f(x)$.

*Proof.*

Clearly $0 \in \partial f(x)$ if and only if $x$ is a global minimum of $f$. Now assume that $x$ is local minimum of $f$. Then for $\gamma$ small enough one has for any $y$,
$$f(x) \leq f((1-\gamma) x + \gamma y) \leq (1-\gamma) f(x) + \gamma f(y) ,$$
which implies $f(x) \leq f(y)$ and thus $x$ is a global minimum of $f$.

The nice behavior of convex functions will allow for very fast algorithms to optimize them. This alone would not be sufficient to justify the importance of this class of functions (after all constant functions are pretty easy to optimize). However it turns out that surprisingly many optimization problems admit a convex (re)formulation. The excellent book \cite{BV04} describes in great details the various methods that one can employ to uncover the convex aspects of an optimization problem. We will not repeat these arguments here, but we have already seen that many famous machine learning problems (SVM, ridge regression, logistic regression, LASSO, sparse covariance estimation, and matrix completion) are formulated as convex problems.

We conclude this section with a simple extension of the optimality condition ``$0 \in \partial f(x)$'' to the case of constrained optimization. We state this result in the case of a differentiable function for sake of simplicity.

**Proposition** (First order optimality condition)
 \label{prop:firstorder}
Let $f$ be convex and $\cX$ a closed convex set on which $f$ is differentiable. Then
$$x^* \in \argmin_{x \in \cX} f(x) ,$$
if and only if one has
$$\nabla f(x^*)^{\top}(x^*-y) \leq 0, \forall y \in \cX .$$

*Proof.*

The ``if" direction is trivial by using that a gradient is also a subgradient. For the ``only if" direction it suffices to note that if $\nabla f(x)^{\top} (y-x) < 0$, then $f$ is locally decreasing around $x$ on the line to $y$ (simply consider $h(t) = f(x + t (y-x))$ and note that $h'(0) = \nabla f(x)^{\top} (y-x)$).