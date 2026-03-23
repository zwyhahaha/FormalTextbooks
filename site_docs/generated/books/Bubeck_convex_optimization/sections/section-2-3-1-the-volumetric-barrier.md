# Bubeck Convex Optimization / Section 2.3.1 — The volumetric barrier

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\subsection{The volumetric barrier}
Let $A \in \mathbb{R}^{m \times n}$ where the $i^{th}$ row is $a_i \in \mathbb{R}^n$, and let $b \in \mathbb{R}^m$. We consider the logarithmic barrier $F$ for the polytope $\{x \in \mathbb{R}^n : A x > b\}$ defined by

\[
F(x) = - \sum_{i=1}^m \log(a_i^{\top} x - b_i) .
\]

We also consider the volumetric barrier $v$ defined by

\[
v(x) = \frac{1}{2} \mathrm{logdet}(\nabla^2 F(x) ) .
\]

The intuition is clear: $v(x)$ is equal to the logarithm of the inverse volume of the Dikin ellipsoid (for the logarithmic barrier) at $x$. It will be useful to spell out the hessian of the logarithmic barrier:

\[
\nabla^2 F(x) = \sum_{i=1}^m \frac{a_i a_i^{\top}}{(a_i^{\top} x - b_i)^2} .
\]

Introducing the leverage score

\[
\sigma_i(x) = \frac{(\nabla^2 F(x) )^{-1}[a_i, a_i]}{(a_i^{\top} x - b_i)^2} ,
\]

one can easily verify that

\nabla v(x) = - \sum_{i=1}^m \sigma_i(x) \frac{a_i}{a_i^{\top} x - b_i} ,

and 

\nabla^2 v(x) \succeq \sum_{i=1}^m \sigma_i(x) \frac{a_i a_i^{\top}}{(a_i^{\top} x - b_i)^2} =: Q(x) .

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
