# Bubeck Convex Optimization / Section 5.5.3 — Saddle Point Mirror Prox (SP-MP)

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

\subsection{Saddle Point Mirror Prox (SP-MP)}
We now consider the most interesting situation in the context of this chapter, where the function $\phi$ is smooth. Precisely we say that $\phi$ is $(\beta_{11}, \beta_{12}, \beta_{22}, \beta_{21})$-smooth if for any $x, x' \in \cX, y, y' \in \cY$, 
\begin{align*}
& \|\nabla_x \phi(x,y) - \nabla_x \phi(x',y) \|_{\mathcal{X}}^* \leq \beta_{11} \|x-x'\|_{\mathcal{X}} , \\
& \|\nabla_x \phi(x,y) - \nabla_x \phi(x,y') \|_{\mathcal{X}}^* \leq \beta_{12} \|y-y'\|_{\mathcal{Y}} , \\
& \|\nabla_y \phi(x,y) - \nabla_y \phi(x,y') \|_{\mathcal{Y}}^* \leq \beta_{22} \|y-y'\|_{\mathcal{Y}} , \\
& \|\nabla_y \phi(x,y) - \nabla_y \phi(x',y) \|_{\mathcal{Y}}^* \leq \beta_{21} \|x-x'\|_{\mathcal{X}} ,
\end{align*}
This will imply the Lipschitzness of the vector field $g : \cZ \rightarrow \R^n \times \R^m$ under the appropriate norm. Thus we use here mirror prox on the space $\cZ$ with the mirror map $\Phi(z) = a \Phi_{\cX}(x) + b \Phi_{\cY}(y)$ and the vector field $g$. The resulting algorithm is called SP-MP (Saddle Point Mirror Prox) and we can describe it succintly as follows.

Let $z_1 \in \argmin_{z \in \cZ \cap \cD} \Phi(z)$. Then for $t \geq 1$, let $z_t=(x_t,y_t)$ and $w_t=(u_t, v_t)$ be defined by
\begin{eqnarray*}
w_{t+1} & = & \argmin_{z \in \cZ \cap \cD} \ \eta (\nabla_x \phi(x_t, y_t), - \nabla_y \phi(x_t,y_t))^{\top} z + D_{\Phi}(z,z_t) \\
z_{t+1} & = & \argmin_{z \in \cZ \cap \cD} \ \eta (\nabla_x \phi(u_{t+1}, v_{t+1}), - \nabla_y \phi(u_{t+1},v_{t+1}))^{\top} z + D_{\Phi}(z,z_t) .
\end{eqnarray*}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 5.2](../results/theorem-5-2.md) | Theorem 5.2 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem52.lean) |
