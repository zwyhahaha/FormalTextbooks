# Bubeck Convex Optimization / Section 3.4.2 — Strongly convex and smooth functions

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

\subsection{Strongly convex and smooth functions}
As we will see now, having both strong convexity and smoothness allows for a drastic improvement in the convergence rate. We denote $\kappa= \frac{\beta}{\alpha}$ for the {\em condition number} of $f$. The key observation is that Lemma \ref{lem:smoothconst} can be improved to (with the notation of the lemma):

f(x^+) - f(y) \leq g_{\cX}(x)^{\top}(x-y) - \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 - \frac{\alpha}{2} \|x-y\|^2 .

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.10](../results/theorem-3-10.md) | Theorem 3.10 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem310.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Lemma 3.11](../results/lemma-3-11.md) | Lemma 3.11 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma311.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.12](../results/theorem-3-12.md) | Theorem 3.12 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem312.lean) |
