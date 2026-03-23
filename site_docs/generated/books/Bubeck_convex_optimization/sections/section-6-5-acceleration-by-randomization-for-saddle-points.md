# Bubeck Convex Optimization / Section 6.5 — Acceleration by randomization for saddle points

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

\section{Acceleration by randomization for saddle points}
We explore now the use of randomness for saddle point computations. That is we consider the context of Section \ref{sec:sp} with a stochastic oracle of the following form: given $z=(x,y) \in \cX \times \cY$ it outputs $\tg(z) = (\tg_{\cX}(x,y), \tg_{\cY}(x,y))$ where $\E \ (\tg_{\cX}(x,y) | x,y) \in \partial_x \phi(x,y)$, and $\E \ (\tg_{\cY}(x,y) | x,y) \in \partial_y (-\phi(x,y))$. Instead of using true subgradients as in SP-MD (see Section \ref{sec:spmd}) we use here the outputs of the stochastic oracle. We refer to the resulting algorithm as S-SP-MD (Stochastic Saddle Point Mirror Descent). Using the same reasoning than in Section \ref{sec:smd} and Section \ref{sec:spmd} one can derive the following theorem.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.10](../results/theorem-6-10.md) | Theorem 6.10 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem610.lean) |
