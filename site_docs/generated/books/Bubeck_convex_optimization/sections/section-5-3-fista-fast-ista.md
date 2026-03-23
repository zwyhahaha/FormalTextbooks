# Bubeck Convex Optimization / Section 5.3 — FISTA (Fast ISTA)

[Back to Chapter 5](../chapters/chapter-5.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\section*{FISTA (Fast ISTA)}
An obvious idea is to combine Nesterov's accelerated gradient descent (which results in a $1/t^2$ rate to optimize $f$) with ISTA. This results in FISTA (Fast ISTA) which is described as follows. Let

\[
\lambda_0 = 0, \ \lambda_{t} = \frac{1 + \sqrt{1+ 4 \lambda_{t-1}^2}}{2}, \ \text{and} \  \gamma_t = \frac{1 - \lambda_t}{\lambda_{t+1}}.
\]

Let $x_1 = y_1$ an arbitrary initial point, and
\begin{eqnarray*}
y_{t+1} & = & \mathrm{argmin}_{x \in \mathbb{R}^n} \ g(x) + \frac{\beta}{2} \|x - (x_t - \frac1{\beta} \nabla f(x_t)) \|_2^2 , \\
x_{t+1} & = & (1 - \gamma_t) y_{t+1} + \gamma_t y_t .
\end{eqnarray*}
Again it is easy show that the rate of convergence of FISTA on $f+g$ is similar to the one of Nesterov's accelerated gradient descent on $f$, more precisely:

\[
f(y_t) + g(y_t) - (f(x^*) + g(x^*)) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t^2} .
\]

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
