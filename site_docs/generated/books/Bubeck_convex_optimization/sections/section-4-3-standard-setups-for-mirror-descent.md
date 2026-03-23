# Bubeck Convex Optimization / Section 4.3 — Standard setups for mirror descent

[Back to Chapter 4](../chapters/chapter-4.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\section{Standard setups for mirror descent} \label{sec:mdsetups}
\noindent **``Ball setup".** The simplest version of mirror descent is obtained by taking $\Phi(x) = \frac{1}{2} \|x\|^2_2$ on $\mathcal{D} = \mathbb{R}^n$. The function $\Phi$ is a mirror map strongly convex w.r.t. $\|\cdot\|_2$, and furthermore the associated Bregman divergence is given by $D_{\Phi}(x,y) = \frac{1}{2} \|x - y\|^2_2$. Thus in that case mirror descent is exactly equivalent to projected subgradient descent, and the rate of convergence obtained in Theorem \ref{th:MD} recovers our earlier result on projected subgradient descent.
\newline

\noindent
**``Simplex setup".** A more interesting choice of a mirror map is given by the negative entropy

\[
\Phi(x) = \sum_{i=1}^n x(i) \log x(i),
\]

on $\mathcal{D} = \mathbb{R}_{++}^n$. In that case the gradient update $\nabla \Phi(y_{t+1}) = \nabla \Phi(x_t) - \eta \nabla f(x_t)$ can be written equivalently as

\[
y_{t+1}(i) = x_{t}(i) \exp\big(- \eta [\nabla f(x_t) ](i) \big) , \ i=1, \hdots, n.
\]

The Bregman divergence of this mirror map is given by $D_{\Phi}(x,y) = \sum_{i=1}^n x(i) \log \frac{x(i)}{y(i)}$ (also known as the Kullback-Leibler divergence). It is easy to verify that the projection with respect to this Bregman divergence on the simplex $\Delta_n = \{x \in \mathbb{R}_+^n : \sum_{i=1}^n x(i) = 1\}$ amounts to a simple renormalization $y \mapsto y / \|y\|_1$. Furthermore it is also easy to verify that $\Phi$ is $1$-strongly convex w.r.t. $\|\cdot\|_1$ on $\Delta_n$ (this result is known as Pinsker's inequality). Note also that for $\mathcal{X} = \Delta_n$ one has $x_1 = (1/n, \hdots, 1/n)$ and $R^2 = \log n$.

The above observations imply that when minimizing on the simplex $\Delta_n$ a function $f$ with subgradients bounded in $\ell_{\infty}$-norm, mirror descent with the negative entropy achieves a rate of convergence of order $\sqrt{\frac{\log n}{t}}$. On the other hand the regular subgradient descent achieves only a rate of order $\sqrt{\frac{n}{t}}$ in this case!
\newline

\noindent
**``Spectrahedron setup".** We consider here functions defined on matrices, and we are interested in minimizing a function $f$ on the {\em spectrahedron} $\mathcal{S}_n$ defined as:

\[
\mathcal{S}_n = \left\{X \in \mathbb{S}_+^n : \mathrm{Tr}(X) = 1 \right\} .
\]

In this setting we consider the mirror map on $\mathcal{D} = \mathbb{S}_{++}^n$ given by the negative von Neumann entropy:

\[
\Phi(X) = \sum_{i=1}^n \lambda_i(X) \log \lambda_i(X) ,
\]

where $\lambda_1(X), \hdots, \lambda_n(X)$ are the eigenvalues of $X$. It can be shown that the gradient update $\nabla \Phi(Y_{t+1}) = \nabla \Phi(X_t) - \eta \nabla f(X_t)$ can be written equivalently as

\[
Y_{t+1} = \exp\big(\log X_t - \eta \nabla f(X_t) \big) ,
\]

where the matrix exponential and matrix logarithm are defined as usual. Furthermore the projection on $\mathcal{S}_n$ is a simple trace renormalization.

With highly non-trivial computation one can show that $\Phi$ is $\frac{1}{2}$-strongly convex with respect to the Schatten $1$-norm defined as

\[
\|X\|_1 = \sum_{i=1}^n \lambda_i(X).
\]

It is easy to see that for $\mathcal{X} = \mathcal{S}_n$ one has $x_1 = \frac{1}{n} \mI_n$ and $R^2 = \log n$. In other words the rate of convergence for optimization on the spectrahedron is the same than on the simplex!

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
