# Bubeck Convex Optimization / Section 6.4 — Random coordinate descent

[Back to Chapter 6](../chapters/chapter-6.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\section{Random coordinate descent}
We assume throughout this section that $f$ is a convex and differentiable function on $\R^n$, with a unique minimizer $x^*$. We investigate one of the simplest possible scheme to optimize $f$, the random coordinate descent (RCD) method. In the following we denote $\nabla_i f(x) = \frac{\partial f}{\partial x_i} (x)$. RCD is defined as follows, with an arbitrary initial point $x_1 \in \R^n$,

\[
x_{s+1} = x_s - \eta \nabla_{i_s} f(x) e_{i_s} ,
\]

where $i_s$ is drawn uniformly at random from $[n]$ (and independently of everything else). 

One can view RCD as SGD with the specific oracle $\tg(x) = n \nabla_{I} f(x) e_I$ where $I$ is drawn uniformly at random from $[n]$. Clearly $\E \tg(x) = \nabla f(x)$, and furthermore

\[
\E \|\tg(x)\|_2^2 = \frac{1}{n}\sum_{i=1}^n \|n \nabla_{i} f(x) e_i\|_2^2 = n \|\nabla f(x)\|_2^2 .
\]

Thus using Theorem \ref{th:SMD} (with $\Phi(x) = \frac12 \|x\|_2^2$, that is S-MD being SGD) one immediately obtains the following result.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.6](../results/theorem-6-6.md) | Theorem 6.6 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem66.lean) |
