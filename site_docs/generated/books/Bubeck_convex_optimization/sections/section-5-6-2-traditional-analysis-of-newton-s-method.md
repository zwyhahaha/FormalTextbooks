# Bubeck Convex Optimization / Section 5.6.2 — Traditional analysis of Newton's method

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

\subsection{Traditional analysis of Newton's method} \label{sec:tradanalysisNM}
We start by describing Newton's method together with its standard analysis showing the quadratic convergence rate when initialized close enough to the optimum. In this subsection we denote $\|\cdot\|$ for both the Euclidean norm on $\R^n$ and the operator norm on matrices (in particular $\|A x\| \leq \|A\| \cdot \|x\|$).

Let $f: \R^n \rightarrow \R$ be a $C^2$ function. 

Using a Taylor's expansion of $f$ around $x$ one obtains

\[
f(x+h) = f(x) + h^{\top} \nabla f(x) + \frac12 h^{\top} \nabla^2 f(x) h + o(\|h\|^2) .
\]

Thus, starting at $x$, in order to minimize $f$ it seems natural to move in the direction $h$ that minimizes 

\[
h^{\top} \nabla f(x) + \frac12 h^{\top} \nabla f^2(x) h .
\]

If $\nabla^2 f(x)$ is positive definite then the solution to this problem is given by $h = - [\nabla^2 f(x)]^{-1} \nabla f(x)$. Newton's method simply iterates this idea: starting at some point $x_0 \in \R^n$, it iterates for $k \geq 0$ the following equation:

\[
x_{k+1} = x_k  - [\nabla^2 f(x_k)]^{-1} \nabla f(x_k) .
\]

While this method can have an arbitrarily bad behavior in general, if started close enough to a strict local minimum of $f$, it can have a very fast convergence:

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 5.3](../results/theorem-5-3.md) | Theorem 5.3 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem53.lean) |
