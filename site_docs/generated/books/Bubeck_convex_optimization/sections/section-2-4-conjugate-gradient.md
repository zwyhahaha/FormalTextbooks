# Bubeck Convex Optimization / Section 2.4 — Conjugate gradient

[Back to Chapter 2](../chapters/chapter-2.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

<div class="metric-grid">
<div class="metric-card"><span class="metric-label">Proved</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Partial</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Pending</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Failed</span><span class="metric-value">0</span></div>
<div class="metric-card"><span class="metric-label">Total</span><span class="metric-value">0</span></div>
</div>

## Source Context

\section{Conjugate gradient} \label{sec:CG}
We conclude this chapter with the special case of unconstrained optimization of a convex quadratic function $f(x) = \frac12 x^{\top} A x - b^{\top} x$, where $A \in \R^{n \times n}$ is a positive definite matrix and $b \in \R^n$. This problem, of paramount importance in practice (it is equivalent to solving the linear system $Ax = b$), admits a simple first-order black-box procedure which attains the {\em exact} optimum $x^*$ in at most $n$ steps. This method, called the {\em conjugate gradient}, is described and analyzed below. What is written below is taken from [Chapter 5, \cite{NW06}].

Let $\langle \cdot , \cdot\rangle_A$ be the inner product on $\R^n$ defined by the positive definite matrix $A$, that is $\langle x, y\rangle_A = x^{\top} A y$ (we also denote by $\|\cdot\|_A$ the corresponding norm). For sake of clarity we denote here $\langle \cdot , \cdot\rangle$ for the standard inner product in $\R^n$. Given an orthogonal set $\{p_0, \hdots, p_{n-1}\}$ for $\langle \cdot , \cdot \rangle_A$ we will minimize $f$ by sequentially minimizing it along the directions given by this orthogonal set. That is, given $x_0 \in \R^n$, for $t \geq 0$ let

x_{t+1} := \argmin_{x \in \{x_t + \lambda p_t, \ \lambda \in \R\}} f(x) .

Equivalently one can write

x_{t+1} = x_t - \langle \nabla f(x_t) , p_t \rangle \frac{p_t}{\|p_t\|_A^2} .

The latter identity follows by differentiating $\lambda \mapsto f(x + \lambda p_t)$, and using that $\nabla f(x) = A x - b$. We also make an observation that will be useful later, namely that $x_{t+1}$ is the minimizer of $f$ on $x_0 + \mathrm{span}\{p_0, \hdots, p_t\}$, or equivalently

\langle \nabla f(x_{t+1}), p_i \rangle = 0, \forall \ 0 \leq i \leq t.

Equation \eqref{eq:CG3prime} is true by construction for $i=t$, and for $i \leq t-1$ it follows by induction, assuming \eqref{eq:CG3prime} at $t=1$ and using the following formula:

\nabla f(x_{t+1}) = \nabla f(x_{t}) - \langle \nabla f(x_{t}) , p_{t} \rangle \frac{A p_{t}}{\|p_t\|_A^2} .

We now claim that $x_n = x^* = \argmin_{x \in \R^n} f(x)$. It suffices to show that $\langle x_n -x_0 , p_t \rangle_A = \langle x^*-x_0 , p_t \rangle_A$ for any $t\in \{0,\hdots,n-1\}$. Note that $x_n - x_0 = - \sum_{t=0}^{n-1} \langle \nabla f(x_t), p_t \rangle \frac{p_t}{\|p_t\|_A^2}$, and thus using that $x^* = A^{-1} b$,
\begin{eqnarray*}
\langle x_n -x_0 , p_t \rangle_A = - \langle \nabla f(x_t) , p_t \rangle = \langle b - A x_t , p_t \rangle & = & \langle x^* - x_t, p_t \rangle_A \\
& = &  \langle x^* - x_0, p_t \rangle_A ,
\end{eqnarray*}
which concludes the proof of $x_n = x^*$.
\newline

In order to have a proper black-box method it remains to describe how to build iteratively the orthogonal set $\{p_0, \hdots, p_{n-1}\}$ based only on gradient evaluations of $f$. A natural guess to obtain a set of orthogonal directions (w.r.t. $\langle \cdot , \cdot \rangle_A$) is to take $p_0 = \nabla f(x_0)$ and for $t \geq 1$,

p_t = \nabla f(x_t) - \langle \nabla f(x_t), p_{t-1} \rangle_A \ \frac{p_{t-1}}{\|p_{t-1}\|^2_A} .

Let us first verify by induction on $t \in [n-1]$ that for any $i \in \{0,\hdots,t-2\}$, $\langle p_t, p_{i}\rangle_A = 0$ (observe that for $i=t-1$ this is true by construction of $p_t$). Using the induction hypothesis one can see that it is enough to show $\langle \nabla f(x_t), p_i \rangle_A = 0$ for any $i \in \{0, \hdots, t-2\}$, which we prove now. First observe that by induction one easily obtains $A p_i \in \mathrm{span}\{p_0, \hdots, p_{i+1}\}$ from \eqref{eq:CG3} and \eqref{eq:CG4}. Using this fact together with $\langle \nabla f(x_t), p_i \rangle_A = \langle \nabla f(x_t), A p_i \rangle$ and \eqref{eq:CG3prime} thus concludes the proof of orthogonality of the set $\{p_0, \hdots, p_{n-1}\}$.

We still have to show that \eqref{eq:CG4} can be written by making only reference to the gradients of $f$ at previous points. Recall that $x_{t+1}$ is the minimizer of $f$ on $x_0 + \mathrm{span}\{p_0, \hdots, p_t\}$, and thus given the form of $p_t$ we also have that $x_{t+1}$ is the minimizer of $f$ on $x_0 + \mathrm{span}\{\nabla f(x_0), \hdots, \nabla f(x_t)\}$ (in some sense the conjugate gradient is the {\em optimal} first order method for convex quadratic functions). In particular one has $\langle \nabla f(x_{t+1}) , \nabla f(x_t) \rangle = 0$. This fact, together with the orthogonality of the set $\{p_t\}$ and \eqref{eq:CG3}, imply that

\[
\frac{\langle \nabla f(x_{t+1}) , p_{t} \rangle_A}{\|p_t\|_A^2} = \langle \nabla f(x_{t+1}) , \frac{A p_{t}}{\|p_t\|_A^2}  \rangle = - \frac{\langle \nabla f(x_{t+1})  , \nabla f(x_{t+1}) \rangle}{\langle \nabla f(x_{t})  , p_t \rangle} .
\]

Furthermore using the definition \eqref{eq:CG4} and $\langle \nabla f(x_t) , p_{t-1} \rangle = 0$ one also has

\[
\langle \nabla f(x_t), p_t \rangle = \langle \nabla f(x_t) , \nabla f(x_t) \rangle .
\]

Thus we arrive at the following rewriting of the (linear) conjugate gradient algorithm, where we recall that $x_0$ is some fixed starting point and $p_0 = \nabla f(x_0)$,

x_{t+1} & = & \argmin_{x \in \left\{x_t + \lambda p_t, \ \lambda \in \R \right\}} f(x) , \label{eq:CG5} \\
p_{t+1} & = & \nabla f(x_{t+1}) + \frac{\langle \nabla f(x_{t+1})  , \nabla f(x_{t+1}) \rangle}{\langle \nabla f(x_{t})  , \nabla f(x_t) \rangle} p_t . \label{eq:CG6}

Observe that the algorithm defined by \eqref{eq:CG5} and \eqref{eq:CG6} makes sense for an arbitary convex function, in which case it is called the {\em non-linear conjugate gradient}. There are many variants of the non-linear conjugate gradient, and the above form is known as the Fletcher-–Reeves method. Another popular version in practice is the Polak-Ribi{\`e}re method which is based on the fact that for the general non-quadratic case one does not necessarily have $\langle \nabla f(x_{t+1}) , \nabla f(x_t) \rangle = 0$, and thus one replaces \eqref{eq:CG6} by

\[
p_{t+1} = \nabla f(x_{t+1}) + \frac{\langle \nabla f(x_{t+1})  - \nabla f(x_t), \nabla f(x_{t+1}) \rangle}{\langle \nabla f(x_{t})  , \nabla f(x_t) \rangle} p_t .
\]

We refer to \cite{NW06} for more details about these algorithms, as well as for advices on how to deal with the line search in \eqref{eq:CG5}.

Finally we also note that the linear conjugate gradient method can often attain an approximate solution in much fewer than $n$ steps. More precisely, denoting $\kappa$ for the condition number of $A$ (that is the ratio of the largest eigenvalue to the smallest eigenvalue of $A$), one can show that linear conjugate gradient attains an $\epsilon$ optimal point in a number of iterations of order $\sqrt{\kappa} \log(1/\epsilon)$. The next chapter will demistify this convergence rate, and in particular we will see that (i) this is the optimal rate among first order methods, and (ii) there is a way to generalize this rate to non-quadratic convex functions (though the algorithm will have to be modified).

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
