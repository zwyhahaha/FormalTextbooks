# Bubeck Convex Optimization / Section 1.6 — Overview of the results and disclaimer

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

\section{Overview of the results and disclaimer}
The overarching aim of this monograph is to present the main complexity theorems in convex optimization and the corresponding algorithms. We focus on five major results in convex optimization which give the overall structure of the text: the existence of efficient cutting-plane methods with optimal oracle complexity (Chapter \ref{finitedim}), a complete characterization of the relation between first order oracle complexity and curvature in the objective function (Chapter \ref{dimfree}), first order methods beyond Euclidean spaces (Chapter \ref{mirror}), non-black box methods (such as interior point methods) can give a quadratic improvement in the number of iterations with respect to optimal black-box methods (Chapter \ref{beyond}), and finally noise robustness of first order methods (Chapter \ref{rand}). Table \ref{table} can be used as a quick reference to the results proved in Chapter \ref{finitedim} to Chapter \ref{beyond}, as well as some of the results of Chapter \ref{rand} (this last chapter is the most relevant to machine learning but the results are also slightly more specific which make them harder to summarize).

An important disclaimer is that the above selection leaves out methods derived from duality arguments, as well as the two most popular research avenues in convex optimization: (i) using convex optimization in non-convex settings, and (ii) practical large-scale algorithms. Entire books have been written on these topics, and new books have yet to be written on the impressive collection of new results obtained for both (i) and (ii) in the past five years. 

A few of the blatant omissions regarding (i) include (a) the theory of submodular optimization (see \cite{Bac13}), (b) convex relaxations of combinatorial problems (a short example is given in Section \ref{sec:convexrelaxation}), and (c) methods inspired from convex optimization for non-convex problems such as low-rank matrix factorization (see e.g. \cite{JNS13} and references therein), neural networks optimization, etc. 

With respect to (ii) the most glaring omissions include (a) heuristics (the only heuristic briefly discussed here is the non-linear conjugate gradient in Section \ref{sec:CG}), (b) methods for distributed systems, and (c) adaptivity to unknown parameters. Regarding (a) we refer to \cite{NW06} where the most practical algorithms are discussed in great details (e.g., quasi-newton methods such as BFGS and L-BFGS, primal-dual interior point methods, etc.). The recent survey \cite{BPCPE11} discusses the alternating direction method of multipliers (ADMM) which is a popular method to address (b). Finally (c) is a subtle and important issue. In the entire monograph the emphasis is on presenting the algorithms and proofs in the simplest way, and thus for sake of convenience we assume that the relevant parameters describing the regularity and curvature of the objective function (Lipschitz constant, smoothness constant, strong convexity parameter) are known and can be used to tune the algorithm's own parameters. Line search is a powerful technique to replace the knowledge of these parameters and it is heavily used in practice, see again \cite{NW06}. We observe however that from a theoretical point of view (c) is only a matter of logarithmic factors as one can always run in parallel several copies of the algorithm with different guesses for the values of the parameters.}. Overall the attitude of this text with respect to (ii) is best summarized by a quote of Thomas Cover: ``theory is the first term in the Taylor series of practice'', \cite{Cov92}.
\newline

**Notation.** We always denote by $x^*$ a point in $\cX$ such that $f(x^*) = \min_{x \in \cX} f(x)$ (note that the optimization problem under consideration will always be clear from the context). In particular we always assume that $x^*$ exists. For a vector $x \in \R^n$ we denote by $x(i)$ its $i^{th}$ coordinate. The dual of a norm $\|\cdot\|$ (defined later) will be denoted either $\|\cdot\|_*$ or $\|\cdot\|^*$ (depending on whether the norm already comes with a subscript). Other notation are standard (e.g., $\mI_n$ for the $n \times n$ identity matrix, $\succeq$ for the positive semi-definite order on matrices, etc).

{\footnotesize
{c|c|c|c|c}
$f$ & {Algorithm} & {Rate} & {\# Iter} & {Cost/iter} 
\\  \hline 

  {{c} non-smooth } &  {{c} center of\\ gravity } & $\exp\left( - \frac{t}{n} \right)$ & $n \log \left(\frac{1}{\epsilon}\right)$ &  {{c} 1 $\nabla$, \\ 1 $n$-dim $\int$ }
\\  \hline 

  {{c} non-smooth } &  {{c} ellipsoid \\ method } & $\frac{R}{r} \exp\left( - \frac{t}{n^2}\right)$ & $n^2 \log \left(\frac{R}{r \epsilon}\right)$ &  {{c} 1 $\nabla$, \\mat-vec $\times$ }
\\  \hline 

  {{c} non-smooth } &  {{c} Vaidya } & $\frac{R n}{r} \exp\left( - \frac{t}{n}\right)$ & $n \log \left(\frac{R n}{r \epsilon}\right)$ &  {{c} 1 $\nabla$, \\mat-mat $\times$ }
\\  \hline 

  {{c} quadratic } &  {{c} CG } & {{c} exact \\ $\exp\left( - \frac{t}{\kappa}\right)$ } & {{c} $n$ \\ $\kappa \log\left(\frac1{\epsilon}\right)$ } &  {{c} 1 $\nabla$ }
\\  \hline 

  {{c} non-smooth, \\ Lipschitz } & {PGD} & $R L /\sqrt{t}$ & $R^2 L^2 /\epsilon^2$ &  {{c} 1 $\nabla$, \\ 1 proj. }
\\  \hline 

  {smooth} & {PGD} & $\beta R^2 / t$ & $\beta R^2 /\epsilon$ &  {{c} 1 $\nabla$, \\ 1 proj. }
\\  \hline 

  {smooth} & {{c} AGD } & $\beta R^2 / t^2$ & $R \sqrt{\beta / \epsilon}$ & 1 $\nabla$ 
\\  \hline 

  {{c} smooth \\ (any norm) }& {FW} & $\beta R^2 / t$ & $\beta R^2 /\epsilon$ &  {{c} 1 $\nabla$, \\ 1 LP }
\\  \hline 

  {{c} strong. conv., \\ Lipschitz } & {PGD} & $L^2 / (\alpha t)$ & $L^2 / (\alpha \epsilon)$ & {{c} 1 $\nabla$ , \\ 1 proj. }
\\  \hline 

  {{c} strong. conv., \\ smooth } & {PGD} & $R^2 \exp\left(-\frac{t}{\kappa}\right)$ & $\kappa \log\left(\frac{R^2}{\epsilon}\right) $ & {{c} 1 $\nabla$ , \\ 1 proj. }
\\  \hline 

  {{c} strong. conv., \\ smooth } & {{c} AGD } & $R^2 \exp\left(-\frac{t}{\sqrt{\kappa}}\right)$ & $\sqrt{\kappa} \log\left(\frac{R^2}{\epsilon}\right) $ & 1 $\nabla$ 
\\  \hline 

  {{c} $f+g$, \\ $f$ smooth, \\ $g$ simple } & FISTA & $\beta R^2 / t^2$ & $R \sqrt{\beta / \epsilon}$ & {{c} 1 $\nabla$  of $f$ \\ Prox of $g$ } 
\\  \hline 

  {{c} $\underset{y \in \cY}{\max} \ \phi(x,y)$, \\ $\phi$ smooth} & SP-MP & $\beta R^2 / t$ & $\beta R^2 /\epsilon$ & {{c} MD on $\cX$ \\ MD on $\cY$ } 
\\  \hline 

  {{c} linear, \\ $\cX$ with $F$ \\$\nu$-self-conc. } & IPM & $\nu \exp\left(- \frac{t}{\sqrt{\nu}}\right)$ & $\sqrt{\nu} \log\left(\frac{\nu}{\epsilon}\right)$ & {{c} Newton \\ step on $F$ }
\\ \hline
  {{c} non-smooth } & {SGD} & $B L /\sqrt{t}$ & $B^2 L^2 /\epsilon^2$ &  {{c} 1 stoch. ${\nabla}$, \\ 1 proj. }
\\ \hline
  {{c} non-smooth, \\ strong. conv. } & {SGD} & $B^2 / (\alpha t)$ & $B^2 / (\alpha \epsilon)$ &  {{c} 1 stoch. $\nabla$, \\ 1 proj. }
\\ \hline
  {{c} $f=\frac1{m} \sum f_i$ \\ $f_i$ smooth \\ strong. conv. } & {SVRG} & -- & $(m + \kappa) \log\left(\frac{1}{\epsilon}\right)$ &  {1 stoch. $\nabla$}
  }
\caption{Summary of the results proved in Chapter \ref{finitedim} to Chapter \ref{beyond} and some of the results in Chapter \ref{rand}.}

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
