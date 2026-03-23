# Bubeck Convex Optimization / Section 2.2 — The ellipsoid method

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">2</span></div>
</div>

## Source Context

\section{The ellipsoid method} \label{sec:ellipsoid}
Recall that an ellipsoid is a convex set of the form

\[
\mathcal{E} = \{x \in \R^n : (x - c)^{\top} H^{-1} (x-c) \leq 1 \} ,
\]

where $c \in \R^n$, and $H$ is a symmetric positive definite matrix. Geometrically $c$ is the center of the ellipsoid, and the semi-axes of $\cE$ are given by the eigenvectors of $H$, with lengths given by the square root of the corresponding eigenvalues.

We give now a simple geometric lemma, which is at the heart of the ellipsoid method.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="partial"><span class="status-badge status-partial">Partial</span></span> | [Lemma 2.3](../results/lemma-2-3.md) | Lemma 2.3 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma23.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 2.4](../results/theorem-2-4.md) | Theorem 2.4 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem24.lean) |
