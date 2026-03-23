# Bubeck Convex Optimization / Section 4.0 — Almost dimension-free convex optimization in non-Euclidean spaces

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

In the previous chapter we showed that dimension-free oracle complexity is possible when the objective function $f$ and the constraint set $\cX$ are well-behaved in the Euclidean norm; e.g. if for all points $x \in \cX$ and all subgradients $g \in \partial f(x)$, one has that $\|x\|_2$ and $\|g\|_2$ are independent of the ambient dimension $n$. If this assumption is not met then the gradient descent techniques of Chapter \ref{dimfree} may lose their dimension-free convergence rates. For instance consider a differentiable convex function $f$ defined on the Euclidean ball $\mB_{2,n}$ and such that $\|\nabla f(x)\|_{\infty} \leq 1, \forall x \in \mB_{2,n}$. This implies that $\|\nabla f(x)\|_{2} \leq \sqrt{n}$, and thus projected gradient descent will converge to the minimum of $f$ on $\mB_{2,n}$ at a rate $\sqrt{n / t}$. In this chapter we describe the method of \cite{NY83}, known as mirror descent, which allows to find the minimum of such functions $f$ over the $\ell_1$-ball (instead of the Euclidean ball) at the much faster rate $\sqrt{\log(n) / t}$. This is only one example of the potential of mirror descent. This chapter is devoted to the description of mirror descent and some of its alternatives. The presentation is inspired from \cite{BT03}, [Chapter 11, \cite{CL06}], \cite{Rak09, Haz11, Bub11}.
\newpage

In order to describe the intuition behind the method let us abstract the situation for a moment and forget that we are doing optimization in finite dimension. We already observed that projected gradient descent works in an arbitrary Hilbert space $\mathcal{H}$. Suppose now that we are interested in the more general situation of optimization in some Banach space $\mathcal{B}$. In other words the norm that we use to measure the various quantity of interest does not derive from an inner product (think of $\mathcal{B} = \ell_1$ for example). In that case the gradient descent strategy does not even make sense: indeed the gradients (more formally the Fr\'echet derivative) $\nabla f(x)$ are elements of the dual space $\mathcal{B}^*$ and thus one cannot perform the computation $x - \eta \nabla f(x)$ (it simply does not make sense). We did not have this problem for optimization in a Hilbert space $\mathcal{H}$ since by Riesz representation theorem $\mathcal{H}^*$ is isometric to $\mathcal{H}$. The great insight of Nemirovski and Yudin is that one can still do a gradient descent by first mapping the point $x \in \mathcal{B}$ into the dual space $\mathcal{B}^*$, then performing the gradient update in the dual space, and finally mapping back the resulting point to the primal space $\mathcal{B}$. Of course the new point in the primal space might lie outside of the constraint set $\mathcal{X} \subset \mathcal{B}$ and thus we need a way to project back the point on the constraint set $\mathcal{X}$. Both the primal/dual mapping and the projection are based on the concept of a {\em mirror map} which is the key element of the scheme. Mirror maps are defined in Section \ref{sec:mm}, and the above scheme is formally described in Section \ref{sec:MD}.

In the rest of this chapter we fix an arbitrary norm $\|\cdot\|$ on $\R^n$, and a compact convex set $\cX \subset \R^n$. The dual norm $\|\cdot\|_*$ is defined as $\|g\|_* = \sup_{x \in \mathbb{R}^n : \|x\| \leq 1} g^{\top} x$. We say that a convex function $f : \cX \rightarrow \R$ is (i) $L$-Lipschitz w.r.t. $\|\cdot\|$ if $\forall x \in \cX, g \in \partial f(x), \|g\|_* \leq L$, (ii) $\beta$-smooth w.r.t. $\|\cdot\|$ if $\|\nabla f(x) - \nabla f(y) \|_* \leq \beta \|x-y\|, \forall x, y \in \cX$, and (iii) $\alpha$-strongly convex w.r.t. $\|\cdot\|$ if 

\[
f(x) - f(y) \leq g^{\top} (x - y) - \frac{\alpha}{2} \|x - y \|^2 , \forall x, y \in \cX, g \in \partial f(x).
\]
 We also define the Bregman divergence associated to $f$ as 

\[
D_{f}(x,y) = f(x) - f(y) - \nabla f(y)^{\top} (x - y) .
\]

The following identity will be useful several times:

(\nabla f(x) - \nabla f(y))^{\top}(x-z) = D_{f}(x,y) + D_{f}(z,x) - D_{f}(z,y) .

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
