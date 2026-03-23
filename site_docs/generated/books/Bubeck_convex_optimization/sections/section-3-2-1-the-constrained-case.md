# Bubeck Convex Optimization / Section 3.2.1 — The constrained case

[Back to Chapter 3](../chapters/chapter-3.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">2</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">2</span></div>
</div>

## Source Context

\subsection*{The constrained case}
We now come back to the constrained problem
\begin{align*}
& \mathrm{min.} \; f(x) \\
& \text{s.t.} \; x \in \cX .
\end{align*}
Similarly to what we did in Section \ref{sec:psgd} we consider the projected gradient descent algorithm, which iterates $x_{t+1} = \Pi_{\cX}(x_t - \eta \nabla f(x_t))$. 

The key point in the analysis of gradient descent for unconstrained smooth optimization is that a step of gradient descent started at $x$ will decrease the function value by at least $\frac{1}{2\beta} \|\nabla f(x)\|^2$, see \eqref{eq:onestepofgd}. In the constrained case we cannot expect that this would still hold true as a step may be cut short by the projection. The next lemma defines the ``right" quantity to measure progress in the constrained case.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Lemma 3.6](../results/lemma-3-6.md) | Lemma 3.6 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma36.lean) |
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Theorem 3.7](../results/theorem-3-7.md) | Theorem 3.7 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem37.lean) |
