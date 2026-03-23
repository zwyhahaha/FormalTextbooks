# Bubeck Convex Optimization / Section 2.3 — Vaidya's cutting plane method

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\section{Vaidya's cutting plane method}
We focus here on the feasibility problem (it should be clear from the previous sections how to adapt the argument for optimization). We have seen that for the feasibility problem the center of gravity has a $O(n)$ oracle complexity and unclear computational complexity (see Section \ref{sec:rwmethod} for more on this), while the ellipsoid method has oracle complexity $O(n^2)$ and computational complexity $O(n^4)$. We describe here the beautiful algorithm of \cite{Vai89, Vai96} which has oracle complexity $O(n \log(n))$ and computational complexity $O(n^4)$, thus getting the best of both the center of gravity and the ellipsoid method. In fact the computational complexity can even be improved further, and the recent breakthrough \cite{LSW15} shows that it can essentially (up to logarithmic factors) be brought down to $O(n^3)$.

This section, while giving a fundamental algorithm, should probably be skipped on a first reading. In particular we use several concepts from the theory of interior point methods which are described in Section \ref{sec:IPM}.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
