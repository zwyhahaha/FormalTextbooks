# Bubeck Convex Optimization / Section 6.7 — Random walk based methods

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

\section{Random walk based methods} \label{sec:rwmethod}
Randomization naturally suggests itself in the center of gravity method (see Section \ref{sec:gravity}), as a way to circumvent the exact calculation of the center of gravity. This idea was proposed and developed in \cite{BerVem04}. We give below a condensed version of the main ideas of this paper.

Assuming that one can draw independent points $X_1, \hdots, X_N$ uniformly at random from the current set $\cS_t$, one could replace $c_t$ by $\hat{c}_t = \frac{1}{N} \sum_{i=1}^N X_i$. \cite{BerVem04} proved the following generalization of Lemma \ref{lem:Gru60} for the situation where one cuts a convex set through a point close the center of gravity. Recall that a convex set $\cK$ is in isotropic position if $\E X = 0$ and $\E X X^{\top} = \mI_n$, where $X$ is a random variable drawn uniformly at random from $\cK$. Note in particular that this implies $\E \|X\|_2^2 = n$. We also say that $\cK$ is in near-isotropic position if $\frac{1}{2} \mI_n \preceq \E X X^{\top} \preceq \frac3{2} \mI_n$.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Lemma 6.14](../results/lemma-6-14.md) | Lemma 6.14 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma614.lean) |
