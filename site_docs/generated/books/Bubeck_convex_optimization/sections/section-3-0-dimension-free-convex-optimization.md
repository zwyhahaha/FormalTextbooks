# Bubeck Convex Optimization / Section 3.0 — Dimension-free convex optimization

[Back to Chapter 3](../chapters/chapter-3.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

We investigate here variants of the {\em gradient descent} scheme. This iterative algorithm, which can be traced back to \cite{Cau47}, is the simplest strategy to minimize a differentiable function $f$ on $\R^n$. Starting at some initial point $x_1 \in \R^n$ it iterates the following equation:

x_{t+1} = x_t - \eta \nabla f(x_t) ,

where $\eta > 0$ is a fixed step-size parameter. The rationale behind \eqref{eq:Cau47} is to make a small step in the direction that minimizes the local first order Taylor approximation of $f$ (also known as the steepest descent direction). 

As we shall see, methods of the type \eqref{eq:Cau47} can obtain an oracle complexity {\em independent of the dimension}. This feature makes them particularly attractive for optimization in very high dimension.

Apart from Section \ref{sec:FW}, in this chapter $\|\cdot\|$ denotes the Euclidean norm. The set of constraints $\cX \subset \R^n$ is assumed to be compact and convex. 

We define the projection operator $\Pi_{\cX}$ on $\cX$ by

\[
\Pi_{\cX}(x) = \argmin_{y \in \mathcal{X}} \|x - y\| .
\]

The following lemma will prove to be useful in our study. It is an easy corollary of Proposition \ref{prop:firstorder}, see also Figure \ref{fig:pythagore}.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Lemma 3.1](../results/lemma-3-1.md) | Lemma 3.1 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma31.lean) |
