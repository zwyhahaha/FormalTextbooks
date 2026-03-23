# Bubeck Convex Optimization / Section 5.5.2 — Saddle Point Mirror Descent (SP-MD)

[Back to Chapter 5](../chapters/chapter-5.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">1</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">1</span></div>
</div>

## Source Context

\subsection{Saddle Point Mirror Descent (SP-MD)} \label{sec:spmd}
We consider here mirror descent on the space $\cZ = \cX \times \cY$ with the mirror map $\Phi(z) = a \Phi_{\cX}(x) + b \Phi_{\cY}(y)$ (defined on $\cD = \cD_{\cX} \times \cD_{\cY}$), where $a, b \in \R_+$ are to be defined later, and with the vector field $g : \cZ \rightarrow \R^n \times \R^m$ defined in the previous subsection. We call the resulting algorithm SP-MD (Saddle Point Mirror Descent). It can be described succintly as follows.

Let $z_1 \in \argmin_{z \in \cZ \cap \cD} \Phi(z)$. Then for $t \geq 1$, let

\[
z_{t+1} \in \argmin_{z \in \cZ \cap \cD} \ \eta g_t^{\top} z + D_{\Phi}(z,z_t) ,
\]

where $g_t = (g_{\cX,t}, g_{\cY,t})$ with $g_{\cX,t} \in \partial_x \phi(x_t,y_t)$ and $g_{\cY,t} \in \partial_y (- \phi(x_t,y_t))$.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 5.1](../results/theorem-5-1.md) | Theorem 5.1 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem51.lean) |
