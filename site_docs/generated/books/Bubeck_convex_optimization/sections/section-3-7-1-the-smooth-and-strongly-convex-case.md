# Bubeck Convex Optimization / Section 3.7.1 — The smooth and strongly convex case

[Back to Chapter 3](../chapters/chapter-3.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\subsection{The smooth and strongly convex case}

Nesterov's accelerated gradient descent, illustrated in Figure \ref{fig:nesterovacc}, can be described as follows: Start at an arbitrary initial point 
$x_1 = y_1$ and then iterate the following equations for $t \geq 1$,
\begin{eqnarray*}
y_{t+1} & = & x_t  - \frac{1}{\beta} \nabla f(x_t) , \\
x_{t+1} & = & \left(1 + \frac{\sqrt{\kappa}-1}{\sqrt{\kappa}+1} \right) y_{t+1} - \frac{\sqrt{\kappa}-1}{\sqrt{\kappa}+1} y_t .
\end{eqnarray*}

\node [tokens=1] (noeud1) at (0.5,1) [label=below right:{$x_s$}] {};
\node [tokens=1] (noeud2) at (1.5,-1) [label=below right:{$y_{s}$}] {};
\node [tokens=1] (noeud3) at (2.5,2) [label=below right:{$y_{s+1}$}] {};
\node [tokens=1] (noeud4) at (2.8,3) [label=above left:{$x_{s+1}$}] {};
\draw[->, thick] (noeud1) -- (noeud3) node[midway, left] {$-\frac{1}{\beta}\nabla f(x_s)$};
\draw[thick, dashed] (noeud2) -- (noeud4) {};
\node [tokens=1] (noeud5) at (4.5,3.3) [label=below right:{$y_{s+2}$}] {};
\node [tokens=1] (noeud6) at (5.3,3.8) [label=right:{$x_{s+2}$}] {};
\draw[->, thick] (noeud4) -- (noeud5) {};
\draw[thick, dashed] (noeud3) -- (noeud6) {};

\caption{Illustration of Nesterov's accelerated gradient descent.}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 3.18](../results/theorem-3-18.md) | Theorem 3.18 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem318.lean) |
