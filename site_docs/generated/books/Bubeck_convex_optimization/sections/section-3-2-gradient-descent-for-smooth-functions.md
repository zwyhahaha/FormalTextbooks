# Bubeck Convex Optimization / Section 3.2 — Gradient descent for smooth functions

[Back to Chapter 3](../chapters/chapter-3.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">3</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">3</span></div>
</div>

## Source Context

\section{Gradient descent for smooth functions} \label{sec:gdsmooth}
We say that a continuously differentiable function $f$ is $\beta$-smooth if the gradient $\nabla f$ is $\beta$-Lipschitz, that is 

\[
\|\nabla f(x) - \nabla f(y) \| \leq \beta \|x-y\| .
\]

Note that if $f$ is twice differentiable then this is equivalent to the eigenvalues of the Hessians being smaller than $\beta$.
In this section we explore potential improvements in the rate of convergence under such a smoothness assumption.
In order to avoid technicalities we consider first the unconstrained situation, where $f$ is a convex and $\beta$-smooth function on $\R^n$. 
The next theorem shows that {\em gradient descent}, which iterates $x_{t+1} = x_t - \eta \nabla f(x_t)$, attains a much faster rate in this situation than in the non-smooth case of the previous section.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Theorem 3.3](../results/theorem-3-3.md) | Theorem 3.3 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem33.lean) |
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Lemma 3.4](../results/lemma-3-4.md) | Lemma 3.4 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma34.lean) |
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Lemma 3.5](../results/lemma-3-5.md) | Lemma 3.5 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma35.lean) |
