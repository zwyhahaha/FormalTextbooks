# Bubeck Convex Optimization / Section 5.5.1 — Saddle point computation

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

\subsection{Saddle point computation} \label{sec:sp}
Let $\cX \subset \R^n$, $\cY \subset \R^m$ be compact and convex sets. Let $\phi : \cX \times \cY \rightarrow \mathbb{R}$ be a continuous function, such that $\phi(\cdot, y)$ is convex and $\phi(x, \cdot)$ is concave. We write $g_{\cX}(x,y)$ (respectively $g_{\cY}(x,y)$) for an element of $\partial_x \phi(x,y)$ (respectively $\partial_y (-\phi(x,y))$). We are interested in computing

\[
\min_{x \in \cX} \max_{y \in \cY} \phi(x,y) .
\]

By Sion's minimax theorem there exists a pair $(x^*, y^*) \in \cX \times \cY$ such that

\[
\phi(x^*,y^*) = \min_{x \in \mathcal{X}} \max_{y \in \mathcal{Y}} \phi(x,y) = \max_{y \in \mathcal{Y}} \min_{x \in \mathcal{X}} \phi(x,y) .
\]

We will explore algorithms that produce a candidate pair of solutions $(\tx, \ty) \in \cX \times \cY$. The quality of $(\tx, \ty)$ is evaluated through the so-called duality gap} \phi(\tx,y) - \phi(x^*,y^*)$ and the dual gap $\phi(x^*,y^*) - \min_{x \in \mathcal{X}} \phi(x, \ty)$.}

\[
\max_{y \in \mathcal{Y}} \phi(\tx,y) - \min_{x \in \mathcal{X}} \phi(x,\ty) .
\]

The key observation is that the duality gap can be controlled similarly to the suboptimality gap $f(x) - f(x^*)$ in a simple convex optimization problem. Indeed for any $(x, y) \in \cX \times \cY$,

\[
\phi(\tx,\ty) - \phi(x,\ty) \leq g_{\cX}(\tx,\ty)^{\top} (\tx-x),
\]

and 

\[
- \phi(\tx,\ty) - (- \phi(\tx,y)) \leq g_{\cY}(\tx,\ty)^{\top} (\ty-y) .
\]

In particular, using the notation $z = (x,y) \in \cZ := \cX \times \cY$ and $g(z) = (g_{\cX}(x,y), g_{\cY}(x,y))$ we just proved

\max_{y \in \mathcal{Y}} \phi(\tx,y) - \min_{x \in \mathcal{X}} \phi(x,\ty) \leq g(\tz)^{\top} (\tz - z) , 

for some $z \in \mathcal{Z}.$ In view of the vector field point of view developed in Section \ref{sec:vectorfield} this suggests to do a mirror descent in the $\cZ$-space with the vector field $g : \cZ \rightarrow \R^n \times \R^m$. 

We will assume in the next subsections that $\cX$ is equipped with a mirror map $\Phi_{\cX}$ (defined on $\cD_{\cX}$) which is $1$-strongly convex w.r.t. a norm $\|\cdot\|_{\cX}$ on $\cX \cap \cD_{\cX}$. We denote $R^2_{\cX} = \sup_{x \in \cX} \Phi(x) - \min_{x \in \cX} \Phi(x)$. We define similar quantities for the space $\cY$.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
