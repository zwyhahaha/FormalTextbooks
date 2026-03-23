# Bubeck Convex Optimization / Section 5.6.3 — Self-concordant functions

[Back to Chapter 5](../chapters/chapter-5.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">3</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">3</span></div>
</div>

## Source Context

\subsection{Self-concordant functions}
Before giving the definition of self-concordant functions let us try to get some insight into the ``geometry" of Newton's method. Let $A$ be a $n \times n$ non-singular matrix. We look at a Newton step on the functions $f: x \mapsto f(x)$ and $\phi: y \mapsto f(A^{-1} y)$, starting respectively from $x$ and $y= A x$, that is:

\[
x^+ = x  - [\nabla^2 f(x)]^{-1} \nabla f(x) , \; \text{and} \; y^+ = y  - [\nabla^2 \phi(y)]^{-1} \nabla \phi(y) .
\]

By using the following simple formulas

\[
\nabla (x \mapsto f(A x) ) =A^{\top} \nabla f(A x) , \; \text{and} \; \nabla^2 (x \mapsto f(A x) ) =A^{\top} \nabla^2 f(A x) A .
\]

it is easy to show that

\[
y^+ = A x^+ .
\]

In other words Newton's method will follow the same trajectory in the ``$x$-space" and in the ``$y$-space" (the image through $A$ of the $x$-space), that is Newton's method is {\em affine invariant}. Observe that this property is not shared by the methods described in Chapter \ref{dimfree} (except for the conditional gradient descent).

The affine invariance of Newton's method casts some concerns on the assumptions of the analysis in Section \ref{sec:tradanalysisNM}. Indeed the assumptions are all in terms of the canonical inner product in $\R^n$. However we just showed that the method itself does not depend on the choice of the inner product (again this is not true for first order methods). Thus one would like to derive a result similar to Theorem \ref{th:NM} without any reference to a prespecified inner product. The idea of self-concordance is to modify the Lipschitz assumption on the Hessian to achieve this goal.

Assume from now on that $f$ is $C^3$, and let $\nabla^3 f(x) : \R^n \times \R^n \times \R^n \rightarrow \R$ be the third order differential operator. The Lipschitz assumption on the Hessian in Theorem \ref{th:NM} can be written as:

\[
\nabla^3 f(x) [h,h,h] \leq M \|h\|_2^3 .
\]

The issue is that this inequality depends on the choice of an inner product. More importantly it is easy to see that a convex function which goes to infinity on a compact set simply cannot satisfy the above inequality. A natural idea to try fix these issues is to replace the Euclidean metric on the right hand side by the metric given by the function $f$ itself at $x$, that is:

\[
\|h\|_x = \sqrt{ h^{\top} \nabla^2 f(x) h }.
\]

Observe that to be clear one should rather use the notation $\|\cdot\|_{x, f}$, but since $f$ will always be clear from the context we stick to $\|\cdot\|_x$.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Definition 5.4](../results/definition-5-4.md) | Definition 5.4 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition54.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Definition 5.5](../results/definition-5-5.md) | Definition 5.5 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition55.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 5.6](../results/theorem-5-6.md) | Theorem 5.6 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem56.lean) |
