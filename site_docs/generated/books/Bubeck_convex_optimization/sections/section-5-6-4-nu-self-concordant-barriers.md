# Bubeck Convex Optimization / Section 5.6.4 — $\nu$-self-concordant barriers

[Back to Chapter 5](../chapters/chapter-5.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">2</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">2</span></div>
</div>

## Source Context

\subsection{$\nu$-self-concordant barriers}
We deal here with Step (2) of the plan described in Section \ref{sec:barriermethod}. Given Theorem \ref{th:NMsc} we want $t'$ to be as large as possible and such that

\lambda_{F_{t'}}(x^*(t) ) \leq 1/4 .

Since the Hessian of $F_{t'}$ is the Hessian of $F$, one has

\[
\lambda_{F_{t'}}(x^*(t) ) = \|t' c + \nabla F(x^*(t)) \|_{x^*(t)}^* .
\]

Observe that, by first order optimality, one has 

$t c + \nabla F(x^*(t))  = 0,$

which yields

\lambda_{F_{t'}}(x^*(t) ) = (t'-t) \|c\|^*_{x^*(t)} .

Thus taking 

t' = t + \frac{1}{4 \|c\|^*_{x^*(t)}}
 
immediately yields \eqref{eq:trucipm1}. In particular with the value of $t'$ given in \eqref{eq:trucipm2} the Newton's method on $F_{t'}$ initialized at $x^*(t)$ will converge quadratically fast to $x^*(t')$.

It remains to verify that by iterating \eqref{eq:trucipm2} one obtains a sequence diverging to infinity, and to estimate the rate of growth. Thus one needs to control $\|c\|^*_{x^*(t)} = \frac1{t} \|\nabla F(x^*(t))\|_{x^*(t)}^*$. Luckily there is a natural class of functions for which one can control $\|\nabla F(x)\|_x^*$ uniformly over $x$. This is the set of functions such that

\nabla^2 F(x) \succeq \frac1{\nu} \nabla F(x) [\nabla F(x) ]^{\top} .

Indeed in that case one has:
\begin{eqnarray*}
\|\nabla F(x)\|_x^* & = & \sup_{h : h^{\top} \nabla F^2(x) h \leq 1} \nabla F(x)^{\top} h \\
& \leq & \sup_{h : h^{\top} \left( \frac1{\nu} \nabla F(x) [\nabla F(x) ]^{\top} \right) h \leq 1} \nabla F(x)^{\top} h \\
& = & \sqrt{\nu} .
\end{eqnarray*}
Thus a safe choice to increase the penalization parameter is $t' = \left(1 + \frac1{4\sqrt{\nu}}\right) t$. Note that the condition \eqref{eq:nu} can also be written as the fact that the function $F$ is $\frac1{\nu}$-exp-concave, that is $x \mapsto \exp(- \frac1{\nu} F(x))$ is concave. We arrive at the following definition.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Definition 5.7](../results/definition-5-7.md) | Definition 5.7 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition57.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 5.8](../results/theorem-5-8.md) | Theorem 5.8 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem58.lean) |
