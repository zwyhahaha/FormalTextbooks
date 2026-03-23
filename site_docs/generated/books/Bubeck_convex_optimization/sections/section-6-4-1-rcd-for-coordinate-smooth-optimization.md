# Bubeck Convex Optimization / Section 6.4.1 — RCD for coordinate-smooth optimization

[Back to Chapter 6](../chapters/chapter-6.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\subsection{RCD for coordinate-smooth optimization}
We assume now directional smoothness for $f$, that is there exists $\beta_1, \hdots, \beta_n$ such that for any $i \in [n], x \in \R^n$ and $u \in \R$,

\[
| \nabla_i f(x+u e_i) - \nabla_i f(x) | \leq \beta_i |u| .
\]

If $f$ is twice differentiable then this is equivalent to $(\nabla^2 f(x))_{i,i} \leq \beta_i$. In particular, since the maximal eigenvalue of a matrix is upper bounded by its trace, one can see that the directional smoothness implies that $f$ is $\beta$-smooth with $\beta \leq \sum_{i=1}^n \beta_i$. We now study the following ``aggressive" RCD, where the step-sizes are of order of the inverse smoothness:

\[
x_{s+1} = x_s - \frac{1}{\beta_{i_s}} \nabla_{i_s} f(x) e_{i_s} .
\]

Furthermore we study a more general sampling distribution than uniform, precisely for $\gamma \geq 0$ we assume that $i_s$ is drawn (independently) from the distribution $p_{\gamma}$ defined by

\[
p_{\gamma}(i) = \frac{\beta_i^{\gamma}}{\sum_{j=1}^n \beta_j^{\gamma}}, i \in [n] .
\]

This algorithm was proposed in \cite{Nes12}, and we denote it by RCD($\gamma$). Observe that, up to a preprocessing step of complexity $O(n)$, one can sample from $p_{\gamma}$ in time $O(\log(n))$. 

The following rate of convergence is derived in \cite{Nes12}, using the dual norms $\|\cdot\|_{[\gamma]}, \|\cdot\|_{[\gamma]}^*$ defined by

\[
\|x\|_{[\gamma]} = \sqrt{\sum_{i=1}^n \beta_i^{\gamma} x_i^2} , \;\; \text{and} \;\; \|x\|_{[\gamma]}^* = \sqrt{\sum_{i=1}^n \frac1{\beta_i^{\gamma}} x_i^2} .
\]

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.7](../results/theorem-6-7.md) | Theorem 6.7 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem67.lean) |
