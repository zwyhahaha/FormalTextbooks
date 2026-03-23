# Bubeck Convex Optimization / Section 6.2 — Smooth stochastic optimization and mini-batch SGD

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

\section{Smooth stochastic optimization and mini-batch SGD}
In the previous section we showed that, for non-smooth optimization, there is basically no cost for having a stochastic oracle instead of an exact oracle. Unfortunately one can show (see e.g. \cite{Tsy03}) that smoothness does not bring any acceleration for a general stochastic oracle that acceleration can be obtained for the square loss and the logistic loss.}. This is in sharp contrast with the exact oracle case where we showed that gradient descent attains a $1/t$ rate (instead of $1/\sqrt{t}$ for non-smooth), and this could even be improved to $1/t^2$ thanks to Nesterov's accelerated gradient descent. 

The next result interpolates between the $1/\sqrt{t}$ for stochastic smooth optimization, and the $1/t$ for deterministic smooth optimization. We will use it to propose a useful modification of SGD in the smooth case. The proof is extracted from \cite{DGBSX12}.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.3](../results/theorem-6-3.md) | Theorem 6.3 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem63.lean) |
