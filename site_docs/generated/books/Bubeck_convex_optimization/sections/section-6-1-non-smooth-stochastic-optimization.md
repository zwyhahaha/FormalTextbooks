# Bubeck Convex Optimization / Section 6.1 — Non-smooth stochastic optimization

[Back to Chapter 6](../chapters/chapter-6.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">2</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">2</span></div>
</div>

## Source Context

\section{Non-smooth stochastic optimization} \label{sec:smd}
We initiate our study with stochastic mirror descent (S-MD) which is defined as follows: $x_1 \in \argmin_{\cX \cap \cD} \Phi(x)$, and

\[
x_{t+1} = \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \ \eta \tilde{g}(x_t)^{\top} x + D_{\Phi}(x,x_t) .
\]

In this case equation \eqref{eq:vfMD} rewrites

\[
\sum_{s=1}^t \tg(x_s)^{\top} (x_s - x) \leq \frac{R^2}{\eta} + \frac{\eta}{2 \rho} \sum_{s=1}^t \|\tg(x_s)\|_*^2 .
\]

This immediately yields a rate of convergence thanks to the following simple observation based on the tower rule:
\begin{eqnarray*}
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x) & \leq & \frac{1}{t} \E \sum_{s=1}^t (f(x_s) - f(x)) \\
& \leq & \frac{1}{t} \E \sum_{s=1}^t \E(\tg(x_s) | x_s)^{\top} (x_s - x) \\
& = & \frac{1}{t} \E \sum_{s=1}^t \tg(x_s)^{\top} (x_s - x) .
\end{eqnarray*}
We just proved the following theorem.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.1](../results/theorem-6-1.md) | Theorem 6.1 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem61.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.2](../results/theorem-6-2.md) | Theorem 6.2 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem62.lean) |
