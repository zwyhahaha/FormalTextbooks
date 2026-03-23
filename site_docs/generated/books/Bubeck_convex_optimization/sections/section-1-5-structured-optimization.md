# Bubeck Convex Optimization / Section 1.5 — Structured optimization

[Back to Chapter 1](../chapters/chapter-1.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\section{Structured optimization} \label{sec:structured}
The black-box model described in the previous section seems extremely wasteful for the applications we discussed in Section \ref{sec:mlapps}. Consider for instance the LASSO objective: $x \mapsto \|W x - y\|_2^2 + \|x\|_1$. We know this function {\em globally}, and assuming that we can only make local queries through oracles seem like an artificial constraint for the design of algorithms. Structured optimization tries to address this observation. Ultimately one would like to take into account the global structure of both $f$ and $\cX$ in order to propose the most efficient optimization procedure. An extremely powerful hammer for this task are the Interior Point Methods. We will describe this technique in Chapter \ref{beyond} alongside with other more recent techniques such as FISTA or Mirror Prox. 

We briefly describe now two classes of optimization problems for which we will be able to exploit the structure very efficiently, these are the LPs (Linear Programs) and SDPs (Semi-Definite Programs). \cite{BN01} describe a more general class of Conic Programs but we will not go in that direction here.

The class LP consists of problems where $f(x) = c^{\top} x$ for some $c \in \R^n$, and $\mathcal{X} = \{x \in \R^n : A x \leq b \}$ for some $A \in \R^{m \times n}$ and $b \in \R^m$.

The class SDP consists of problems where the optimization variable is a symmetric matrix $X \in \R^{n \times n}$. Let $\mathbb{S}^n$ be the space of $n\times n$ symmetric matrices (respectively $\mathbb{S}^n_+$ is the space of positive semi-definite matrices), and let $\langle \cdot, \cdot \rangle$ be the Frobenius inner product (recall that it can be written as $\langle A, B \rangle = \tr(A^{\top} B)$). In the class SDP the problems are of the following form: $f(x) = \langle X, C \rangle$ for some $C \in \R^{n \times n}$, and $\mathcal{X} = \{X \in \mathbb{S}^n_+ : \langle X, A_i \rangle \leq b_i, i \in \{1, \hdots, m\} \}$ for some $A_1, \hdots, A_m \in \R^{n \times n}$ and $b \in \R^m$. Note that the matrix completion problem described in Section \ref{sec:mlapps} is an example of an SDP.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
