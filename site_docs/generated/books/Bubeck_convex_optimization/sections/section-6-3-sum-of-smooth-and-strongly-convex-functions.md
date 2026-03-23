# Bubeck Convex Optimization / Section 6.3 — Sum of smooth and strongly convex functions

[Back to Chapter 6](../chapters/chapter-6.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">2</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">2</span></div>
</div>

## Source Context

\section{Sum of smooth and strongly convex functions}
Let us examine in more details the main example from Section \ref{sec:mlapps}. That is one is interested in the unconstrained minimization of 

\[
f(x) = \frac1{m} \sum_{i=1}^m f_i(x) ,
\]

where $f_1, \hdots, f_m$ are $\beta$-smooth and convex functions, and $f$ is $\alpha$-strongly convex. Typically in machine learning $\alpha$ can be as small as $1/m$, while $\beta$ is of order of a constant. In other words the condition number $\kappa= \beta / \alpha$ can be as large as $\Omega(m)$. Let us now compare the basic gradient descent, that is

\[
x_{t+1} = x_t - \frac{\eta}{m} \sum_{i=1}^m \nabla f_i(x) ,
\]

to SGD

\[
x_{t+1} = x_t - \eta \nabla f_{i_t}(x) ,
\]

where $i_t$ is drawn uniformly at random in $[m]$ (independently of everything else). Theorem \ref{th:gdssc} shows that gradient descent requires $O(m \kappa \log(1/\epsilon))$ gradient computations (which can be improved to $O(m \sqrt{\kappa} \log(1/\epsilon))$ with Nesterov's accelerated gradient descent), while Theorem \ref{th:sgdstrong} shows that SGD (with appropriate averaging) requires $O(1/ (\alpha \epsilon))$ gradient computations. Thus one can obtain a low accuracy solution reasonably fast with SGD, but for high accuracy the basic gradient descent is more suitable. Can we get the best of both worlds? This question was answered positively in \cite{LRSB12} with SAG (Stochastic Averaged Gradient) and in \cite{SSZ13} with SDCA (Stochastic Dual Coordinate Ascent). These methods require only $O((m+\kappa) \log(1/\epsilon))$ gradient computations. We describe below the SVRG (Stochastic Variance Reduced Gradient descent) algorithm from \cite{JZ13} which makes the main ideas of SAG and SDCA more transparent (see also \cite{DBLJ14} for more on the relation between these different methods). We also observe that a natural question is whether one can obtain a Nesterov's accelerated version of these algorithms that would need only $O((m + \sqrt{m \kappa}) \log(1/\epsilon))$, see \cite{SSZ13b, ZX14, AB14} for recent works on this question.

To obtain a linear rate of convergence one needs to make ``big steps", that is the step-size should be of order of a constant. In SGD the step-size is typically of order $1/\sqrt{t}$ because of the variance introduced by the stochastic oracle. The idea of SVRG is to ``center" the output of the stochastic oracle in order to reduce the variance. Precisely instead of feeding $\nabla f_{i}(x)$ into the gradient descent one would use $\nabla f_i(x) - \nabla f_i(y) + \nabla f(y)$ where $y$ is a centering sequence. This is a sensible idea since, when $x$ and $y$ are close to the optimum, one should have that $\nabla f_i(x) - \nabla f_i(y)$ will have a small variance, and of course $\nabla f(y)$ will also be small (note that $\nabla f_i(x)$ by itself is not necessarily small). This intuition is made formal with the following lemma.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Lemma 6.4](../results/lemma-6-4.md) | Lemma 6.4 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma64.lean) |
| <span data-status="pending"><span class="status-badge status-pending">Pending</span></span> | [Theorem 6.5](../results/theorem-6-5.md) | Theorem 6.5 | [Lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem65.lean) |
