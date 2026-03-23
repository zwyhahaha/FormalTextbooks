# Bubeck Convex Optimization / Section 5.6.1 — The barrier method

[Back to Chapter 5](../chapters/chapter-5.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\subsection{The barrier method} \label{sec:barriermethod}
We say that $F : \inte(\cX) \rightarrow \R$ is a {\em barrier} for $\cX$ if 

\[
F(x) \xrightarrow[x \to \partial \cX]{} +\infty .
\]

We will only consider strictly convex barriers. We extend the domain of definition of $F$ to $\R^n$ with $F(x) = +\infty$ for $x \not\in \inte(\cX)$. For $t \in \R_+$ let

\[
x^*(t) \in \argmin_{x \in \R^n} t c^{\top} x + F(x) .
\]

In the following we denote $F_t(x) := t c^{\top} x + F(x)$.
In IPM the path $(x^*(t))_{t \in \R_+}$ is referred to as the {\em central path}. It seems clear that the central path eventually leads to the minimum $x^*$ of the objective function $c^{\top} x$ on $\cX$, precisely we will have

\[
x^*(t) \xrightarrow[t \to +\infty]{} x^* .
\]

The idea of the {\em barrier method} is to move along the central path by ``boosting" a fast locally convergent algorithm, which we denote for the moment by $\cA$, using the following scheme: Assume that one has computed $x^*(t)$, then one uses $\cA$ initialized at $x^*(t)$ to compute $x^*(t')$ for some $t'>t$. There is a clear tension for the choice of $t'$, on the one hand $t'$ should be large in order to make as much progress as possible on the central path, but on the other hand $x^*(t)$ needs to be close enough to $x^*(t')$ so that it is in the basin of fast convergence for $\cA$ when run on $F_{t'}$. 

IPM follows the above methodology with $\cA$ being {\em Newton's method}. Indeed as we will see in the next subsection, Newton's method has a quadratic convergence rate, in the sense that if initialized close enough to the optimum it attains an $\epsilon$-optimal point in $\log\log(1/\epsilon)$ iterations! Thus we now have a clear plan to make these ideas formal and analyze the iteration complexity of IPM:

\item First we need to describe precisely the region of fast convergence for Newton's method. This will lead us to define self-concordant functions, which are ``natural" functions for Newton's method.
\item Then we need to evaluate precisely how much larger $t'$ can be compared to $t$, so that $x^*(t)$ is still in the region of fast convergence of Newton's method when optimizing the function $F_{t'}$ with $t'>t$. This will lead us to define $\nu$-self concordant barriers.
\item How do we get close to the central path in the first place? Is it possible to compute $x^*(0) = \argmin_{x \in \R^n} F(x)$ (the so-called analytical center of $\mathcal{X}$)?

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
