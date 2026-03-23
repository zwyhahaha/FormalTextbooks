# Bubeck Convex Optimization / Section 2.3.2 — Vaidya's algorithm

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\subsection{Vaidya's algorithm}
We fix $\epsilon \leq 0.006$ a small constant to be specified later. Vaidya's algorithm produces a sequence of pairs $(A^{(t)}, b^{(t)}) \in \mathbb{R}^{m_t \times n} \times \mathbb{R}^{m_t}$ such that the corresponding polytope contains the convex set of interest. The initial polytope defined by $(A^{(0)},b^{(0)})$ is a simplex (in particular $m_0=n+1$). For $t\geq0$ we let $x_t$ be the minimizer of the volumetric barrier $v_t$ of the polytope given by $(A^{(t)}, b^{(t)})$, and $(\sigma_i^{(t)})_{i \in [m_t]}$ the leverage scores (associated to $v_t$) at the point $x_t$. We also denote $F_t$ for the logarithmic barrier given by $(A^{(t)}, b^{(t)})$. The next polytope $(A^{(t+1)}, b^{(t+1)})$ is defined by either adding or removing a constraint to the current polytope:

\item If for some $i \in [m_t]$ one has $\sigma_i^{(t)} = \min_{j \in [m_t]} \sigma_j^{(t)} < \epsilon$, then $(A^{(t+1)}, b^{(t+1)})$ is defined by removing the $i^{th}$ row in $(A^{(t)}, b^{(t)})$ (in particular $m_{t+1} = m_t - 1$).
\item Otherwise let $c^{(t)}$ be the vector given by the separation oracle queried at $x_t$, and $\beta^{(t)} \in \mathbb{R}$ be chosen so that 

\[
\frac{(\nabla^2 F_t(x_t) )^{-1}[c^{(t)}, c^{(t)}]}{(x_t^{\top} c^{(t)} - \beta^{(t)})^2} = \frac{1}{5} \sqrt{\epsilon} .
\]

Then we define $(A^{(t+1)}, b^{(t+1)})$ by adding to $(A^{(t)}, b^{(t)})$ the row given by $(c^{(t)}, \beta^{(t)})$ (in particular $m_{t+1} = m_t + 1$).

It can be shown that the volumetric barrier is a self-concordant barrier, and thus it can be efficiently minimized with Newton's method. In fact it is enough to do {\em one step} of Newton's method on $v_t$ initialized at $x_{t-1}$, see \cite{Vai89, Vai96} for more details on this.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
