# Bubeck Convex Optimization / Section 3.5 — Lower bounds

[Back to Chapter 3](../chapters/chapter-3.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">3</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">3</span></div>
</div>

## Source Context

\section{Lower bounds} \label{sec:chap3LB}
We prove here various oracle complexity lower bounds. These results first appeared in \cite{NY83} but we follow here the simplified presentation of \cite{Nes04}. In general a black-box procedure is a mapping from ``history" to the next query point, that is it maps $(x_1, g_1, \hdots, x_t, g_t)$ (with $g_s \in \partial f (x_s)$) to $x_{t+1}$. In order to simplify the notation and the argument, throughout the section we make the following assumption on the black-box procedure: $x_1=0$ and for any $t \geq 0$, $x_{t+1}$ is in the linear span of $g_1, \hdots, g_t$, that is

x_{t+1} \in \mathrm{Span}(g_1, \hdots, g_t) .

Let $e_1, \hdots, e_n$ be the canonical basis of $\mathbb{R}^n$, and $\mB_2(R) = \{x \in \R^n : \|x\| \leq R\}$. We start with a theorem for the two non-smooth cases (convex and strongly convex).

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.13](../results/theorem-3-13.md) | Theorem 3.13 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem313.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.14](../results/theorem-3-14.md) | Theorem 3.14 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem314.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.15](../results/theorem-3-15.md) | Theorem 3.15 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem315.lean) |
