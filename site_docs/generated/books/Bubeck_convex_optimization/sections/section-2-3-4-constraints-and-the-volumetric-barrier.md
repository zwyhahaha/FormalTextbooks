# Bubeck Convex Optimization / Section 2.3.4 — Constraints and the volumetric barrier

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">3</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">4</span></div>
</div>

## Source Context

\subsection{Constraints and the volumetric barrier} \label{sec:constraintsvolumetric}
We want to understand the effect on the volumetric barrier of addition/deletion of constraints to the polytope. Let $c \in \mathbb{R}^n$, $\beta \in \mathbb{R}$, and consider the logarithmic barrier $\tilde{F}$ and the volumetric barrier $\tilde{v}$ corresponding to the matrix $\tilde{A}\in \mathbb{R}^{(m+1) \times n}$ and the vector $\tilde{b} \in \mathbb{R}^{m+1}$ which are respectively the concatenation of $A$ and $c$, and the concatenation of $b$ and $\beta$. Let $x^*$ and $\tilde{x}^*$ be the minimizer of respectively $v$ and $\tilde{v}$. We recall the definition of leverage scores, for $i \in [m+1]$, where $a_{m+1}=c$ and $b_{m+1}=\beta$,

\[
\sigma_i(x) = \frac{(\nabla^2 F(x) )^{-1}[a_i, a_i]}{(a_i^{\top} x - b_i)^2}, \ \text{and} \ \tilde{\sigma}_i(x) = \frac{(\nabla^2 \tilde{F}(x) )^{-1}[a_i, a_i]}{(a_i^{\top} x - b_i)^2}.
\]

The leverage scores $\sigma_i$ and $\tilde{\sigma}_i$ are closely related:

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="partial"><span class="status-badge status-partial">Partial</span></span> | [Lemma 2.5](../results/lemma-2-5.md) | Lemma 2.5 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma25.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 2.6](../results/theorem-2-6.md) | Theorem 2.6 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem26.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 2.7](../results/theorem-2-7.md) | Theorem 2.7 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem27.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Lemma 2.8](../results/lemma-2-8.md) | Lemma 2.8 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma28.lean) |
