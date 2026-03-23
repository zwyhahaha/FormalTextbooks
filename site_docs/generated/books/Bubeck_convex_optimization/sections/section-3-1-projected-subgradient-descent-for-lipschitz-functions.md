# Bubeck Convex Optimization / Section 3.1 — Projected subgradient descent for Lipschitz functions

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

\section{Projected subgradient descent for Lipschitz functions} \label{sec:psgd}
In this section we assume that $\cX$ is contained in an Euclidean ball centered at $x_1 \in \cX$ and of radius $R$. Furthermore we assume that $f$ is such that for any $x \in \cX$ and any $g \in \partial f(x)$ (we assume $\partial f(x) \neq \emptyset$), one has $\|g\| \leq L$. Note that by the subgradient inequality and Cauchy-Schwarz this implies that $f$ is $L$-Lipschitz on $\cX$, that is $|f(x) - f(y)| \leq L \|x-y\|$. 

In this context we make two modifications to the basic gradient descent \eqref{eq:Cau47}. First, obviously, we replace the gradient $\nabla f(x)$ (which may not exist) by a subgradient $g \in \partial f(x)$. Secondly, and more importantly, we make sure that the updated point lies in $\cX$ by projecting back (if necessary) onto it. This gives the {\em projected subgradient descent} algorithm) \leq f(x_t)$. In that sense the projected subgradient descent is not a descent method.} which iterates the following equations for $t \geq 1$:

& y_{t+1} = x_t - \eta g_t , \ \text{where} \ g_t \in \partial f(x_t) , \label{eq:PGD1}\\
& x_{t+1} = \Pi_{\cX}(y_{t+1}) . \label{eq:PGD2}

This procedure is illustrated in Figure \ref{fig:pgd}. We prove now a rate of convergence for this method under the above assumptions.

\draw[rotate=30, very thick] (0,0) ellipse (0.5 and 0.7);
\node [tokens=1] (noeud1) at (-0.25,0.1) [label=below right:{$x_t$}] {};
\node [tokens=1] (noeud2) at (-0.8, 0.9) [label=above left:{$y_{t+1}$}] {};
\draw[->, thick] (noeud1) -- (noeud2) node[midway, left] {{c} \\ gradient step \\ \eqref{eq:PGD1} };

\node [tokens=1] (noeud3) at (-60:-0.7) [label=below right:{$x_{t+1}$}] {};
\draw[->, thick] (noeud2) -- (noeud3) node[midway, right] {projection \eqref{eq:PGD2}};
\node at (0.3,-0.4) {$\cX$};

\caption{Illustration of the projected subgradient descent method.}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Theorem 3.2](../results/theorem-3-2.md) | Theorem 3.2 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem32.lean) |
