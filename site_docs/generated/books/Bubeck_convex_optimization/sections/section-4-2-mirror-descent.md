# Bubeck Convex Optimization / Section 4.2 — Mirror descent

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

\section{Mirror descent} \label{sec:MD}
We can now describe the mirror descent strategy based on a mirror map $\Phi$. Let $x_1 \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x)$. Then for $t \geq 1$, let $y_{t+1} \in \mathcal{D}$ such that

\nabla \Phi(y_{t+1}) = \nabla \Phi(x_{t}) - \eta g_t, \ \text{where} \ g_t \in \partial f(x_t) ,

and

x_{t+1} \in \Pi_{\cX}^{\Phi} (y_{t+1}) .

See Figure \ref{fig:MD} for an illustration of this procedure.

\clip (-2.4,-0.7) rectangle (1,1);
\draw[rotate=30, very thick] (0,-0.5) ellipse (0.7 and 1);
\draw[very thick] (-2,0) ellipse (1 and 0.5);
\node (S) [very thick, regular polygon, regular polygon sides=6, draw,
inner sep=20] at (0,0) {};
\node at (0.3,-0.6) {$\cD$};
\node at (-1.9,-0.4) {$\R^n$};
\node at (0.1, -0.2) {$\cX$};
\node [tokens=1] (noeudat) at (-0.1,0.15) [label=right:{$x_t$}] {};
\node [tokens=1] (noeudat1) at (-0.15,-0.1) [label=right:{$x_{t+1}$}] {};
\node [tokens=1] (noeudwt1) at (-0.4,-0.45) [label=below right:{$y_{t+1}$}] {};
\draw[->, thick] (noeudwt1) .. controls (-0.3, -0.45) and (-0.15, -0.2) .. (noeudat1) node[midway, below right] {projection \eqref{eq:MD2}};
\node [tokens=1] (noeudmat) at (-1.62,0.15) [label=right:{$\nabla \Phi(x_t)$}] {};
\node [tokens=1] (noeudmwt1) at (-1.42,-0.1) [label=right:{$\nabla \Phi(y_{t+1})$}] {};
\draw[->, thick] (noeudmat) -- (noeudmwt1) node[midway, left] {{c} \\ gradient step \\ \eqref{eq:MD1} };
\draw[->, semithick] (noeudat) .. controls (-0.6,0.45) and (-1.12, 0.45) .. (noeudmat) node[midway, above] {$\nabla \Phi$}; 
\draw[->, semithick] (noeudmwt1) .. controls (-1.22,-0.5) and (-0.44, -0.46) .. (noeudwt1) node[midway, below] {$(\nabla \Phi)^{-1}$}; 

\caption{Illustration of mirror descent.}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 4.2](../results/theorem-4-2.md) | Theorem 4.2 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem42.lean) |
