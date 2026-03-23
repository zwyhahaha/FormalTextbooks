# Bubeck Convex Optimization / Section 4.6 — The vector field point of view on MD, DA, and MP

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

\section{The vector field point of view on MD, DA, and MP} \label{sec:vectorfield}
In this section we consider a mirror map $\Phi$ that satisfies the assumptions from Theorem \ref{th:MD}.

By inspecting the proof of Theorem \ref{th:MD} one can see that for arbitrary vectors $g_1, \hdots, g_t \in \R^n$ the mirror descent strategy described by \eqref{eq:MD1} or \eqref{eq:MD2} (or alternatively by \eqref{eq:MDproxview}) satisfies for any $x \in \cX \cap \cD$,

\sum_{s=1}^t g_s^{\top} (x_s - x) \leq \frac{R^2}{\eta} + \frac{\eta}{2 \rho} \sum_{s=1}^t \|g_s\|_*^2 .

The observation that the sequence of vectors $(g_s)$ does not have to come from the subgradients of a {\em fixed} function $f$ is the starting point for the theory of online learning, see \cite{Bub11} for more details. In this monograph we will use this observation to generalize mirror descent to saddle point calculations as well as stochastic settings. We note that we could also use dual averaging (defined by \eqref{eq:DA0}) which satisfies

\[
\sum_{s=1}^t g_s^{\top} (x_s - x) \leq \frac{R^2}{\eta} + \frac{2 \eta}{\rho} \sum_{s=1}^t \|g_s\|_*^2 .
\]

In order to generalize mirror prox we simply replace the gradient $\nabla f$ by an arbitrary vector field $g: \cX \rightarrow \R^n$ which yields the following equations:
\begin{align*}
& \nabla \Phi(y_{t+1}') = \nabla \Phi(x_{t}) - \eta g(x_t), \\
& y_{t+1} \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,y_{t+1}') , \\ 
& \nabla \Phi(x_{t+1}') = \nabla \Phi(x_{t}) - \eta g(y_{t+1}), \\
& x_{t+1} \in \argmin_{x \in \mathcal{X} \cap \mathcal{D}} D_{\Phi}(x,x_{t+1}') .
\end{align*}
Under the assumption that the vector field is $\beta$-Lipschitz w.r.t. $\|\cdot\|$, i.e., $\|g(x) - g(y)\|_* \leq \beta \|x-y\|$ one obtains with $\eta = \frac{\rho}{\beta}$

\sum_{s=1}^t g(y_{s+1})^{\top}(y_{s+1} - x) \leq \frac{\beta R^2}{\rho}.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
