# Bubeck Convex Optimization / Section 4.5 — Mirror prox

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

\section{Mirror prox}
It can be shown that mirror descent accelerates for smooth functions to the rate $1/t$. We will prove this result in Chapter \ref{rand} (see Theorem \ref{th:SMDsmooth}). We describe here a variant of mirror descent which also attains the rate $1/t$ for smooth functions. This method is called mirror prox and it was introduced in \cite{Nem04}. 

The true power of mirror prox will reveal itself later in the text when we deal with smooth representations of non-smooth functions as well as stochastic oracles), while mirror descent does not.}.

Mirror prox is described by the following equations:
\begin{align*}
& \nabla \Phi(y_{t+1}') = \nabla \Phi(x_{t}) - \eta \nabla f(x_t), \\ \\
& y_{t+1} \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,y_{t+1}') , \\  \\
& \nabla \Phi(x_{t+1}') = \nabla \Phi(x_{t}) - \eta \nabla f(y_{t+1}), \\ \\
& x_{t+1} \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,x_{t+1}') .
\end{align*}
In words the algorithm first makes a step of mirror descent to go from $x_t$ to $y_{t+1}$, and then it makes a similar step to obtain $x_{t+1}$, starting again from $x_t$ but this time using the gradient of $f$ evaluated at $y_{t+1}$ (instead of $x_t$), see Figure \ref{fig:mp} for an illustration. The following result justifies the procedure.

\clip (-2.4,-0.7) rectangle (0.5,1);
\draw[rotate=30, very thick] (0,-0.5) ellipse (0.73 and 1);
\draw[very thick] (-2,0) ellipse (1 and 0.5);
\node (S) [very thick, regular polygon, regular polygon sides=6, draw,
inner sep=22] at (0,0) {};
\node at (0.3,-0.6) {$\cD$};
\node at (-2.2,-0.4) {$\R^n$};
\node at (0.12, -0.22) {$\cX$};
\node [tokens=1] (noeudat) at (-0.1,0.15) [label=right:{$x_t$}] {};
\node [tokens=1] (noeudat1) at (-0.15,-0.13) [label=right:{$y_{t+1}$}] {};
\node [tokens=1] (noeudwt1) at (-0.4,-0.45) [label=below right:{$y_{t+1}'$}] {};
\draw[->, thick] (noeudwt1) .. controls (-0.3, -0.45) and (-0.15, -0.2) .. (noeudat1) node[midway, below right] {projection};
\node [tokens=1] (noeudat3) at (-0.2,0) [label=right:{$x_{t+1}$}] {};
\node [tokens=1] (noeudwt3) at (-0.3,-0.2) [label=left:{$x_{t+1}'$}] {};
\draw[->, thick] (noeudwt3) .. controls (-0.22, -0.12) and (-0.22, -0.1) .. (noeudat3) {};
\node [tokens=1] (noeudmat) at (-1.7,0.3) [label=right:{$\nabla \Phi(x_t)$}] {};
\node [tokens=1] (noeudmwt1) at (-2,-0.2) [label=below right:{$\nabla \Phi(y_{t+1}')$}] {};
\node [tokens=1] (noeudmwt2) at (-1.6,-0.1) [label=right:{$\nabla \Phi(x_{t+1}')$}] {};
\draw[->, thick] (noeudmat) -- (noeudmwt2) node[midway, right] {$- \eta \nabla f(y_{t+1})$};
\draw[->, thick, dashed] (noeudmat) -- (noeudmwt1) node[midway, left] {$- \eta \nabla f(x_t)$};
\draw[->, semithick] (-0.4,0.5) .. controls (-0.7,0.6) and (-1, 0.6) .. (-1.3,0.5) node[midway, above] {$\nabla \Phi$}; 
\draw[->, semithick] (-1.45,-0.5) .. controls (-1.15,-0.6) and (-0.85, -0.6) .. (-0.55,-0.5) node[midway, below] {$(\nabla \Phi)^{-1}$}; 

\caption{Illustration of mirror prox.}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 4.4](../results/theorem-4-4.md) | Theorem 4.4 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem44.lean) |
