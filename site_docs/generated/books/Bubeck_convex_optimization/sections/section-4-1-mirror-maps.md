# Bubeck Convex Optimization / Section 4.1 — Mirror maps

[Back to Chapter 4](../chapters/chapter-4.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\section{Mirror maps} \label{sec:mm}
Let $\cD \subset \R^n$ be a convex open set such that $\mathcal{X}$ is included in its closure, that is $\mathcal{X} \subset \overline{\mathcal{D}}$, and $\mathcal{X} \cap \mathcal{D} \neq \emptyset$. We say that $\Phi : \cD \rightarrow \R$ is a mirror map if it safisfies the following properties.}:

\item[(i)] $\Phi$ is strictly convex and differentiable.
\item[(ii)] The gradient of $\Phi$ takes all possible values, that is $\nabla \Phi(\cD) = \R^n$.
\item[(iii)] The gradient of $\Phi$ diverges on the boundary of $\cD$, that is 

\[
\lim_{x \rightarrow \partial \mathcal{D}} \|\nabla \Phi(x)\| = + \infty .
\]

In mirror descent the gradient of the mirror map $\Phi$ is used to map points from the ``primal" to the ``dual" (note that all points lie in $\R^n$ so the notions of primal and dual spaces only have an intuitive meaning). Precisely a point $x \in \mathcal{X} \cap \mathcal{D}$ is mapped to $\nabla \Phi(x)$, from which one takes a gradient step to get to $\nabla \Phi(x) - \eta \nabla f(x)$. Property (ii) then allows us to write the resulting point as $\nabla \Phi(y) = \nabla \Phi(x) - \eta \nabla f(x)$ for some $y \in \cD$. The primal point $y$ may lie outside of the set of constraints $\cX$, in which case one has to project back onto $\cX$. In mirror descent this projection is done via the Bregman divergence associated to $\Phi$. Precisely one defines

\[
\Pi_{\cX}^{\Phi} (y) = \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,y) .
\]

Property (i) and (iii) ensures the existence and uniqueness of this projection (in particular since $x \mapsto D_{\Phi}(x,y)$ is locally increasing on the boundary of $\mathcal{D}$). The following lemma shows that the Bregman divergence essentially behaves as the Euclidean norm squared in terms of projections (recall Lemma \ref{lem:todonow}).

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Lemma 4.1](../results/lemma-4-1.md) | Lemma 4.1 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma41.lean) |
