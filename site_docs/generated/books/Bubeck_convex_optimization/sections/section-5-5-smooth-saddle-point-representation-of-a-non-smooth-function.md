# Bubeck Convex Optimization / Section 5.5 — Smooth saddle-point representation of a non-smooth function

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

\section{Smooth saddle-point representation of a non-smooth function} \label{sec:sprepresentation}
Quite often the non-smoothness of a function $f$ comes from a $\max$ operation. More precisely non-smooth functions can often be represented as

f(x) = \max_{1 \leq i \leq m} f_i(x) ,

where the functions $f_i$ are smooth. This was the case for instance with the function we used to prove the black-box lower bound $1/\sqrt{t}$ for non-smooth optimization in Theorem \ref{th:lb1}. We will see now that by using this structural representation one can in fact attain a rate of $1/t$. This was first observed in \cite{Nes04b} who proposed the Nesterov's smoothing technique. Here we will present the alternative method of \cite{Nem04} which we find more transparent (yet another version is the Chambolle-Pock algorithm, see \cite{CP11}). Most of what is described in this section can be found in \cite{JN11a, JN11b}.

In the next subsection we introduce the more general problem of saddle point computation. We then proceed to apply a modified version of mirror descent to this problem, which will be useful both in Chapter \ref{rand} and also as a warm-up for the more powerful modified mirror prox that we introduce next.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
