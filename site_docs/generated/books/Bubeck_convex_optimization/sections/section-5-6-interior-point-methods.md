# Bubeck Convex Optimization / Section 5.6 — Interior point methods

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

\section{Interior point methods} \label{sec:IPM}
We describe here interior point methods (IPM), a class of algorithms fundamentally different from what we have seen so far. The first algorithm of this type was described in \cite{Kar84}, but the theory we shall present was developed in \cite{NN94}. We follow closely the presentation given in [Chapter 4, \cite{Nes04}]. Other useful references (in particular for the primal-dual IPM, which are the ones used in practice) include \cite{Ren01, Nem04b, NW06}.
\newline

IPM are designed to solve convex optimization problems of the form
\begin{align*}
& \mathrm{min.} \; c^{\top} x \\
& \text{s.t.} \; x \in \cX ,
\end{align*}
with $c \in \R^n$, and $\cX \subset \R^n$ convex and compact. 

Note that, at this point, the linearity of the objective is without loss of generality as minimizing a convex function $f$ over $\cX$ is equivalent to minimizing a linear objective over the epigraph of $f$ (which is also a convex set). The structural assumption on $\cX$ that one makes in IPM is that there exists a {\em self-concordant barrier} for $\cX$ with an easily computable gradient and Hessian. The meaning of the previous sentence will be made precise in the next subsections. The importance of IPM stems from the fact that LPs and SDPs (see Section \ref{sec:structured}) satisfy this structural assumption.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
