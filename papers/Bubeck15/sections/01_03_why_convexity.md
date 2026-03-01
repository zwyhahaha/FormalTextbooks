---
book: Bubeck15
chapter: 1
chapter_title: ''
subsection: 3
subsection_title: Why convexity?
section_id: '1.3'
theorems:
- id: Proposition 1.1
  label: ''
- id: Proposition 1.2
  label: Local minima are global minima
- id: Proposition 1.3
  label: First order optimality condition
lean_files:
- id: Proposition 1.1
  path: proofs/Bubeck15/Proposition11.lean
  status: pending
- id: Proposition 1.2
  path: proofs/Bubeck15/Proposition12.lean
  status: pending
- id: Proposition 1.3
  path: proofs/Bubeck15/Proposition13.lean
  status: pending
---

## 1.3 Why convexity?

The key to the algorithmic success in minimizing convex functions is
that these functions exhibit a local to global phenomenon. We have
already seen one instance of this in Proposition 1.1, where we showed
that ∇f (x) ∈ ∂f (x): the gradient ∇f (x) contains a priori only local
information about the function f around x while the subdiﬀerential
∂f (x) gives a global information in the form of a linear lower bound on
the entire function. Another instance of this local to global phenomenon
is that local minima of convex functions are in fact global minima:

Proposition 1.2 (Local minima are global minima). Let f be convex. If x
is a local minimum of f then x is a global minimum of f . Furthermore
this happens if and only if 0 ∈ ∂f (x).

Proof. Clearly 0 ∈ ∂f (x) if and only if x is a global minimum of f .
Now assume that x is local minimum of f . Then for γ small enough
one has for any y,

f (x) ≤ f ((1 − γ)x + γy) ≤ (1 − γ)f (x) + γf (y),

which implies f (x) ≤ f (y) and thus x is a global minimum of f .

The nice behavior of convex functions will allow for very fast algo-
rithms to optimize them. This alone would not be suﬃcient to justify
the importance of this class of functions (after all constant functions
are pretty easy to optimize). However it turns out that surprisingly
many optimization problems admit a convex (re)formulation. The ex-
cellent book Boyd and Vandenberghe [2004] describes in great details
the various methods that one can employ to uncover the convex aspects
of an optimization problem. We will not repeat these arguments here,
but we have already seen that many famous machine learning problems
(SVM, ridge regression, logistic regression, LASSO, sparse covariance
estimation, and matrix completion) are formulated as convex problems.
We conclude this section with a simple extension of the optimality
condition “0 ∈ ∂f (x)” to the case of constrained optimization. We state
this result in the case of a diﬀerentiable function for sake of simplicity.

238

Introduction

Proposition 1.3 (First order optimality condition). Let f be convex and
X a closed convex set on which f is diﬀerentiable. Then

x∗ ∈ argmin

f (x),

x∈X

if and only if one has

∇f (x∗)>(x∗ − y) ≤ 0, ∀y ∈ X .

Proof. The “if" direction is trivial by using that a gradient is also
a subgradient. For the “only if" direction it suﬃces to note that if
∇f (x)>(y − x) < 0, then f is locally decreasing around x on the
line to y (simply consider h(t) = f (x + t(y − x)) and note that
h0(0) = ∇f (x)>(y − x)).