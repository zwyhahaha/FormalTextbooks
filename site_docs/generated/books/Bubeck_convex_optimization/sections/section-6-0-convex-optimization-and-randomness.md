# Bubeck Convex Optimization / Section 6.0 — Convex optimization and randomness

[Back to Chapter 6](../chapters/chapter-6.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

In this chapter we explore the interplay between optimization and randomness. A key insight, going back to \cite{RM51}, is that first order methods are quite robust: the gradients do not have to be computed exactly to ensure progress towards the optimum. Indeed since these methods usually do many small steps, as long as the gradients are correct {\em on average}, the error introduced by the gradient approximations will eventually vanish. As we will see below this intuition is correct for non-smooth optimization (since the steps are indeed small) but the picture is more subtle in the case of smooth optimization (recall from Chapter \ref{dimfree} that in this case we take long steps).

We introduce now the main object of this chapter: a (first order) {\em stochastic} oracle for a convex function $f : \cX \rightarrow \R$ takes as input a point $x \in \cX$ and outputs a random variable $\tg(x)$ such that $\E \ \tg(x) \in \partial f(x)$. In the case where the query point $x$ is a random variable (possibly obtained from previous queries to the oracle), one assumes that $\E \ (\tg(x) | x) \in \partial f(x)$.

The unbiasedness assumption by itself is not enough to obtain rates of convergence, one also needs to make assumptions about the fluctuations of $\tg(x)$.  Essentially in the non-smooth case we will assume that there exists $B >0$ such that $\E \|\tg(x)\|_*^2 \leq B^2$ for all $x \in \cX$, while in the smooth case we assume that there exists $\sigma > 0$ such that  $\E \|\tg(x) - \nabla f(x)\|_*^2 \leq \sigma^2$ for all $x \in \cX$.

We also note that the situation with a {\em biased} oracle is quite different, and we refer to \cite{Asp08, SLRB11} for some works in this direction.

The two canonical examples of a stochastic oracle in machine learning are as follows. 

Let $f(x) = \E_{\xi} \ell(x, \xi)$ where $\ell(x, \xi)$ should be interpreted as the loss of predictor $x$ on the example $\xi$. We assume that $\ell(\cdot, \xi)$ is a (differentiable) convex function for any $\xi$. The goal is to find a predictor with minimal expected loss, that is to minimize $f$. When queried at $x$ the stochastic oracle can draw $\xi$ from the unknown distribution and report $\nabla_x \ell(x, \xi)$. One obviously has $\E_{\xi} \nabla_x \ell(x, \xi) \in \partial f(x)$. 

The second example is the one described in Section \ref{sec:mlapps}, where one wants to minimize $f(x) = \frac{1}{m} \sum_{i=1}^m f_i(x)$. In this situation a stochastic oracle can be obtained by selecting uniformly at random $I \in [m]$ and reporting $\nabla f_I(x)$.

Observe that the stochastic oracles in the two above cases are quite different. Consider the standard situation where one has access to a data set of i.i.d. samples $\xi_1, \hdots, \xi_m$. Thus in the first case, where one wants to minimize the {\em expected loss}, one is limited to $m$ queries to the oracle, that is to a {\em single pass} over the data (indeed one cannot ensure that the conditional expectations are correct if one uses twice a data point). On the contrary for the {\em empirical loss} where $f_i(x) = \ell(x, \xi_i)$ one can do as many passes as one wishes.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
