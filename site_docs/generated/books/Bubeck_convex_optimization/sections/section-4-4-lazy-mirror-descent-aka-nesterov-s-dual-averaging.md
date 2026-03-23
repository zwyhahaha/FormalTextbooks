# Bubeck Convex Optimization / Section 4.4 — Lazy mirror descent, aka Nesterov's dual averaging

[Back to Chapter 4](../chapters/chapter-4.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\section{Lazy mirror descent, aka Nesterov's dual averaging}
In this section we consider a slightly more efficient version of mirror descent for which we can prove that Theorem \ref{th:MD} still holds true. This alternative algorithm can be advantageous in some situations (such as distributed settings), but the basic mirror descent scheme remains important for extensions considered later in this text (saddle points, stochastic oracles, ...). 

In lazy mirror descent, also commonly known as Nesterov's dual averaging or simply dual averaging, one replaces \eqref{eq:MD1} by

\[
\nabla \Phi(y_{t+1}) = \nabla \Phi(y_{t}) - \eta g_t ,
\]

and also $y_1$ is such that $\nabla \Phi(y_1) = 0$. In other words instead of going back and forth between the primal and the dual, dual averaging simply averages the gradients in the dual, and if asked for a point in the primal it simply maps the current dual point to the primal using the same methodology as mirror descent. In particular using \eqref{eq:MD3} one immediately sees that dual averaging is defined by:

x_t = \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \eta \sum_{s=1}^{t-1} g_s^{\top} x + \Phi(x) .

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 4.3](../results/theorem-4-3.md) | Theorem 4.3 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem43.lean) |
