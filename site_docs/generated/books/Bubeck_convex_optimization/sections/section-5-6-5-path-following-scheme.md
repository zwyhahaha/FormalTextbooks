# Bubeck Convex Optimization / Section 5.6.5 — Path-following scheme

[Back to Chapter 5](../chapters/chapter-5.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\subsection{Path-following scheme}
We can now formally describe and analyze the most basic IPM called the {\em path-following scheme}. Let $F$ be $\nu$-self-concordant barrier for $\cX$. Assume that one can find $x_0$ such that $\lambda_{F_{t_0}}(x_0) \leq 1/4$ for some small value $t_0 >0$ (we describe a method to find $x_0$ at the end of this subsection).

Then for $k \geq 0$, let
\begin{eqnarray*}
& & t_{k+1} = \left(1 + \frac1{13\sqrt{\nu}}\right) t_k ,\\
& & x_{k+1} = x_k - [\nabla^2 F(x_k)]^{-1} (t_{k+1} c + \nabla F(x_k) ) .
\end{eqnarray*}
The next theorem shows that after $O\left( \sqrt{\nu} \log \frac{\nu}{t_0 \epsilon} \right)$ iterations of the path-following scheme one obtains an $\epsilon$-optimal point.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 5.9](../results/theorem-5-9.md) | Theorem 5.9 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem59.lean) |
