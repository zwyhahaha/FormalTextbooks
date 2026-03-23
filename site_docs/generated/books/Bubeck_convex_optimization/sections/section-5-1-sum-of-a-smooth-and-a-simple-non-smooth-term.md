# Bubeck Convex Optimization / Section 5.1 — Sum of a smooth and a simple non-smooth term

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

\section{Sum of a smooth and a simple non-smooth term} \label{sec:simplenonsmooth}
We consider here the following problem.}:

\[
\min_{x \in \R^n} f(x) + g(x) ,
\]

where $f$ is convex and $\beta$-smooth, and $g$ is convex. We assume that $f$ can be accessed through a first order oracle, and that $g$ is known and ``simple". What we mean by simplicity will be clear from the description of the algorithm. For instance a separable function, that is $g(x) = \sum_{i=1}^n g_i(x(i))$, will be considered as simple. The prime example being $g(x) = \|x\|_1$. This section is inspired from \cite{BT09} (see also \cite{Nes07, WNF09}).

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
