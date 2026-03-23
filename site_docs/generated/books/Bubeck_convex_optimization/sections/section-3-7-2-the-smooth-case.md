# Bubeck Convex Optimization / Section 3.7.2 — The smooth case

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

\subsection{The smooth case}

In this section we show how to adapt Nesterov's accelerated gradient descent for the case $\alpha=0$, using a time-varying combination of the elements in the primary sequence $(y_t)$. First we define the following sequences:

\[
\lambda_0 = 0, \ \lambda_{t} = \frac{1 + \sqrt{1+ 4 \lambda_{t-1}^2}}{2}, \ \text{and} \  \gamma_t = \frac{1 - \lambda_t}{\lambda_{t+1}}.
\]

(Note that $\gamma_t \leq 0$.) Now the algorithm is simply defined by the following equations, with $x_1 = y_1$ an arbitrary initial point,
\begin{eqnarray*}
y_{t+1} & = & x_t  - \frac{1}{\beta} \nabla f(x_t) , \\
x_{t+1} & = & (1 - \gamma_s) y_{t+1} + \gamma_t y_t .
\end{eqnarray*}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.19](../results/theorem-3-19.md) | Theorem 3.19 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem319.lean) |
