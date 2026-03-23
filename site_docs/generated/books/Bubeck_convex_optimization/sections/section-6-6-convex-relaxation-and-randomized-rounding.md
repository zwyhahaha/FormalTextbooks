# Bubeck Convex Optimization / Section 6.6 — Convex relaxation and randomized rounding

[Back to Chapter 6](../chapters/chapter-6.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">3</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">3</span></div>
</div>

## Source Context

\section{Convex relaxation and randomized rounding} \label{sec:convexrelaxation}

In this section we briefly discuss the concept of convex relaxation, and the use of randomization to find approximate solutions. By now there is an enormous literature on these topics, and we refer to \cite{Bar14} for further pointers. 

We study here the seminal example of $\mathrm{MAXCUT}$. This problem can be described as follows. Let $A \in \R_+^{n \times n}$ be a symmetric matrix of non-negative weights. The entry $A_{i,j}$ is interpreted as a measure of the ``dissimilarity" between point $i$ and point $j$. The goal is to find a partition of $[n]$ into two sets, $S \subset [n]$ and $S^c$, so as to maximize the total dissimilarity between the two groups: $\sum_{i \in S, j \in S^c} A_{i,j}$. Equivalently $\mathrm{MAXCUT}$ corresponds to the following optimization problem:

\max_{x \in \{-1,1\}^n} \frac12 \sum_{i,j =1}^n A_{i,j} (x_i - x_j)^2 .

Viewing $A$ as the (weighted) adjacency matrix of a graph, one can rewrite \eqref{eq:maxcut1} as follows, using the graph Laplacian $L=D-A$ where $D$ is the diagonal matrix with entries $(\sum_{j=1}^n A_{i,j})_{i \in [n]}$,

\max_{x \in \{-1,1\}^n} x^{\top} L x .

It turns out that this optimization problem is $**NP**$-hard, that is the existence of a polynomial time algorithm to solve \eqref{eq:maxcut2} would prove that $**P** = **NP**$. The combinatorial difficulty of this problem stems from the hypercube constraint. Indeed if one replaces $\{-1,1\}^n$ by the Euclidean sphere, then one obtains an efficiently solvable problem (it is the problem of computing the maximal eigenvalue of $L$).

We show now that, while \eqref{eq:maxcut2} is a difficult optimization problem, it is in fact possible to find relatively good {\em approximate} solutions by using the power of randomization. 
Let $\zeta$ be uniformly drawn on the hypercube $\{-1,1\}^n$, then clearly

\[
\E \ \zeta^{\top} L \zeta = \sum_{i,j=1, i \neq j}^n A_{i,j} \geq \frac{1}{2} \max_{x \in \{-1,1\}^n} x^{\top} L x .
\]

This means that, on average, $\zeta$ is a $1/2$-approximate solution to \eqref{eq:maxcut2}. Furthermore it is immediate that the above expectation bound implies that, with probability at least $\epsilon$, $\zeta$ is a $(1/2-\epsilon)$-approximate solution. Thus by repeatedly sampling uniformly from the hypercube one can get arbitrarily close (with probability approaching $1$) to a $1/2$-approximation of $\mathrm{MAXCUT}$.

Next we show that one can obtain an even better approximation ratio by combining the power of convex optimization and randomization. This approach was pioneered by \cite{GW95}. The Goemans-Williamson algorithm is based on the following inequality

\[
\max_{x \in \{-1,1\}^n} x^{\top} L x = \max_{x \in \{-1,1\}^n} \langle L, xx^{\top} \rangle \leq \max_{X \in \mathbb{S}_+^n, X_{i,i}=1, i \in [n]} \langle L, X \rangle .
\]
 
The right hand side in the above display is known as the {\em convex (or SDP) relaxation} of $\mathrm{MAXCUT}$. The convex relaxation is an SDP and thus one can find its solution efficiently with Interior Point Methods (see Section \ref{sec:IPM}). The following result states both the Goemans-Williamson strategy and the corresponding approximation ratio.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.11](../results/theorem-6-11.md) | Theorem 6.11 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem611.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Lemma 6.12](../results/lemma-6-12.md) | Lemma 6.12 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma612.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.13](../results/theorem-6-13.md) | Theorem 6.13 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem613.lean) |
