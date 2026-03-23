# Bubeck Convex Optimization / Section 5.0 — Beyond the black-box model

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

In the black-box model non-smoothness dramatically deteriorates the rate of convergence of first order methods from $1/t^2$ to $1/\sqrt{t}$. However, as we already pointed out in Section \ref{sec:structured}, we (almost) always know the function to be optimized {\em globally}. In particular the ``source" of non-smoothness can often be identified. For instance the LASSO objective (see Section \ref{sec:mlapps}) is non-smooth, but it is a sum of a smooth part (the least squares fit) and a {\em simple} non-smooth part (the $\ell_1$-norm). Using this specific structure we will propose in Section \ref{sec:simplenonsmooth} a first order method with a $1/t^2$ convergence rate, despite the non-smoothness. In Section \ref{sec:sprepresentation} we consider another type of non-smoothness that can effectively be overcome, where the function is the maximum of smooth functions. Finally we conclude this chapter with a concise description of interior point methods, for which the structural assumption is made on the constraint set rather than on the objective function.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
