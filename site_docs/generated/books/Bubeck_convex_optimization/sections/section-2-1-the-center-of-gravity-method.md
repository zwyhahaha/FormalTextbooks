# Bubeck Convex Optimization / Section 2.1 — The center of gravity method

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">2</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">2</span></div>
</div>

## Source Context

\section{The center of gravity method} \label{sec:gravity}
We consider the following simple iterative algorithm: let $\cS_1= \cX$, and for $t \geq 1$ do the following:

\item Compute

c_t = \frac{1}{\mathrm{vol}(\cS_t)} \int_{x \in \cS_t} x dx .

\item Query the first order oracle at $c_t$ and obtain $w_t \in \partial f (c_t)$. Let

\[
\cS_{t+1} = \cS_t \cap \{x \in \R^n : (x-c_t)^{\top} w_t \leq 0\} .
\]

If stopped after $t$ queries to the first order oracle then we use $t$ queries to a zeroth order oracle to output

\[
x_t\in \argmin_{1 \leq r \leq t} f(c_r) .
\]

This procedure is known as the {\em center of gravity method}, it was discovered independently on both sides of the Wall by \cite{Lev65} and \cite{New65}.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="partial"><span class="status-badge status-partial">Partial</span></span> | [Theorem 2.1](../results/theorem-2-1.md) | Theorem 2.1 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem21.lean) |
| <span data-status="partial"><span class="status-badge status-partial">Partial</span></span> | [Lemma 2.2](../results/lemma-2-2.md) | Lemma 2.2 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma22.lean) |
