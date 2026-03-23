# Bubeck Convex Optimization / Section 3.3 — Conditional gradient descent, aka Frank-Wolfe

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

\section{Conditional gradient descent, aka Frank-Wolfe} \label{sec:FW}

We describe now an alternative algorithm to minimize a smooth convex function $f$ over a compact convex set $\mathcal{X}$. The {\em conditional gradient descent}, introduced in \cite{FW56}, performs the following update for $t \geq 1$, where $(\gamma_s)_{s \geq 1}$ is a fixed sequence,

&y_{t} \in \mathrm{argmin}_{y \in \mathcal{X}} \nabla f(x_t)^{\top} y \label{eq:FW1} \\
& x_{t+1} = (1 - \gamma_t) x_t + \gamma_t y_t . \label{eq:FW2}

In words conditional gradient descent makes a step in the steepest descent direction {\em given the constraint set $\cX$}, see Figure \ref{fig:FW} for an illustration. From a computational perspective, a key property of this scheme is that it replaces the projection step of projected gradient descent by a linear optimization over $\cX$, which in some cases can be a much simpler problem. 

\node [tokens=1] (noeud1) at (0.1,-0.1) [label=below right:{$x_t$}] {};
\node [tokens=1] (noeud2) at (-0.38,0.65) [label=above left:{$y_{t}$}] {};
\draw[->, thick] (noeud1) -- (-0.05, 0.4) node[midway, right] {$-\nabla f(x_t)$};
\node [tokens=1] (noeud3) at (-0.065,0.15) [label=below left:{$x_{t+1}$}] {};
\draw[thick, dashed] (noeud1) -- (noeud2) {};
\node at (0.3,-0.55) {$\cX$};
\node (S) [very thick, regular polygon, regular polygon sides=6, draw,
inner sep=40] at (0,0) {};

\caption{Illustration of conditional gradient descent.}

We now turn to the analysis of this method. A major advantage of conditional gradient descent over projected gradient descent is that the former can adapt to smoothness in an arbitrary norm. Precisely let $f$ be $\beta$-smooth in some norm $\|\cdot\|$, that is $\|\nabla f(x) - \nabla f(y) \|_* \leq \beta \|x-y\|$ where the dual norm $\|\cdot\|_*$ is defined as $\|g\|_* = \sup_{x \in \mathbb{R}^n : \|x\| \leq 1} g^{\top} x$. The following result is extracted from \cite{Jag13} (see also \cite{DH78}).

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="proved"><span class="status-badge status-proved">Proved</span></span> | [Theorem 3.8](../results/theorem-3-8.md) | Theorem 3.8 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem38.lean) |
