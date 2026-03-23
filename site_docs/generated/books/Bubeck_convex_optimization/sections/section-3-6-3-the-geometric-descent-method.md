# Bubeck Convex Optimization / Section 3.6.3 — The geometric descent method

[Back to Chapter 3](../chapters/chapter-3.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\subsection{The geometric descent method} \label{sec:GeoDmethod}
Let $x_0 \in \R^n$, $c_0 = x_0^{++}$, and $R_0^2 = \left(1 - \frac{1}{\kappa}\right)\frac{\|\nabla f(x_0)\|^2}{\alpha^2}$. For any $t \geq 0$ let

\[
x_{t+1} = \argmin_{x \in \left\{(1-\lambda) c_t + \lambda x_t^+, \ \lambda \in \R \right\}} f(x) ,
\]

and $c_{t+1}$ (respectively $R^2_{t+1}$) be the center (respectively the squared radius) of the ball given by (the proof of) Lemma \ref{lem:geom} which contains

\[
\mB\left(c_t, R_t^2 - \frac{\|\nabla f(x_{t+1})\|^2}{\alpha^2 \kappa}\right) \cap \mB\left(x_{t+1}^{++}, \frac{\|\nabla f(x_{t+1})\|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right) \right).
\]

Formulas for $c_{t+1}$ and $R^2_{t+1}$ are given at the end of this section.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.17](../results/theorem-3-17.md) | Theorem 3.17 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem317.lean) |
