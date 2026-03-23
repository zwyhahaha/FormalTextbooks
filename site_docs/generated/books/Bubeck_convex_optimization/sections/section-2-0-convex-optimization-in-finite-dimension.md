# Bubeck Convex Optimization / Section 2.0 — Convex optimization in finite dimension

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

Let $\mathcal{X} \subset \R^n$ be a convex body (that is a compact convex set with non-empty interior), and $f : \mathcal{X} \rightarrow [-B,B]$ be a continuous and convex function. Let $r, R>0$ be such that $\mathcal{X}$ is contained in an Euclidean ball of radius $R$ (respectively it contains an Euclidean ball of radius $r$). In this chapter we give several black-box algorithms to solve 
\begin{align*}
& \mathrm{min.} \; f(x) \\
& \text{s.t.} \; x \in \cX .
\end{align*}
As we will see these algorithms have an oracle complexity which is linear (or quadratic) in the dimension, hence the title of the chapter (in the next chapter the oracle complexity will be {\em independent} of the dimension). An interesting feature of the methods discussed here is that they only need a separation oracle for the constraint set $\cX$. In the literature such algorithms are often referred to as {\em cutting plane methods}. In particular these methods can be used to {\em find} a point $x \in \cX$ given only a separating oracle for $\cX$ (this is also known as the {\em feasibility problem}).

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
