# Bubeck Convex Optimization / Section 5.2 — ISTA (Iterative Shrinkage-Thresholding Algorithm)

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

\section*{ISTA (Iterative Shrinkage-Thresholding Algorithm)}
Recall that gradient descent on the smooth function $f$ can be written as (see \eqref{eq:MDproxview})

\[
x_{t+1} = \argmin_{x \in \mathbb{R}^n} \eta \nabla f(x_t)^{\top} x + \frac{1}{2} \|x - x_t\|^2_2 .
\]

Here one wants to minimize $f+g$, and $g$ is assumed to be known and ``simple". Thus it seems quite natural to consider the following update rule, where only $f$ is locally approximated with a first order oracle:

x_{t+1} & = & \argmin_{x \in \mathbb{R}^n} \eta (g(x) + \nabla f(x_t)^{\top} x) + \frac{1}{2} \|x - x_t\|^2_2 \notag \\
& = & \argmin_{x \in \mathbb{R}^n} \ g(x) + \frac{1}{2\eta} \|x - (x_t - \eta \nabla f(x_t)) \|_2^2 . \label{eq:proxoperator}

The algorithm described by the above iteration is known as ISTA (Iterative Shrinkage-Thresholding Algorithm). In terms of convergence rate it is easy to show that ISTA has the same convergence rate on $f+g$ as gradient descent on $f$. More precisely with $\eta=\frac{1}{\beta}$ one has

\[
f(x_t) + g(x_t) - (f(x^*) + g(x^*)) \leq \frac{\beta \|x_1 - x^*\|^2_2}{2 t} .
\]

This improved convergence rate over a subgradient descent directly on $f+g$ comes at a price: in general \eqref{eq:proxoperator} may be a difficult optimization problem by itself, and this is why one needs to assume that $g$ is simple. For instance if $g$ can be written as $g(x) = \sum_{i=1}^n g_i(x(i))$ then one can compute $x_{t+1}$ by solving $n$ convex problems in dimension $1$. In the case where $g(x) = \lambda \|x\|_1$ this one-dimensional problem is given by:

\[
\min_{x \in \mathbb{R}} \ \lambda |x| + \frac{1}{2 \eta}(x - x_0)^2, \ \text{where} \ x_0 \in \mathbb{R} .
\]

Elementary computations shows that this problem has an analytical solution given by $\tau_{\lambda \eta}(x_0)$,
where $\tau$ is the shrinkage operator (hence the name ISTA), defined by

\[
\tau_{\alpha}(x) = (|x|-\alpha)_+ \mathrm{sign}(x) .
\]

Much more is known about \eqref{eq:proxoperator} (which is called the {\em proximal operator} of $g$), and in fact entire monographs have been written about this equation, see e.g. \cite{PB13, BJMO12}.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
