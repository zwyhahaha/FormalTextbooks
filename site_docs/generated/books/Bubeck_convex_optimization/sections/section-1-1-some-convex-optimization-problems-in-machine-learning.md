# Bubeck Convex Optimization / Section 1.1 — Some convex optimization problems in machine learning

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

\section{Some convex optimization problems in machine learning} \label{sec:mlapps}
Many fundamental convex optimization problems in machine learning take the following form:

\underset{x \in \R^n}{\mathrm{min.}} \; \sum_{i=1}^m f_i(x) + \lambda \cR(x) ,

where the functions $f_1, \hdots, f_m, \cR$ are convex and $\lambda \geq 0$ is a fixed parameter. The interpretation is that $f_i(x)$ represents the cost of using $x$ on the $i^{th}$ element of some data set, and $\cR(x)$ is a regularization term which enforces some ``simplicity'' in $x$. We discuss now major instances of \eqref{eq:veryfirst}. In all cases one has a data set of the form $(w_i, y_i) \in \R^n \times \cY, i=1, \hdots, m$ and the cost function $f_i$ depends only on the pair $(w_i, y_i)$. We refer to \cite{HTF01, SS02, SSS14} for more details on the origin of these important problems. The mere objective of this section is to expose the reader to a few concrete convex optimization problems which are routinely solved.
 
In classification one has $\cY = \{-1,1\}$. Taking $f_i(x) = \max(0, 1- y_i x^{\top} w_i)$ (the so-called hinge loss) and $\cR(x) = \|x\|_2^2$ one obtains the SVM problem. On the other hand taking $f_i(x) = \log(1 + \exp(-y_i x^{\top} w_i) )$ (the logistic loss) and again $\cR(x) = \|x\|_2^2$ one obtains the (regularized) logistic regression problem.

In regression one has $\cY = \R$. Taking $f_i(x) = (x^{\top} w_i - y_i)^2$ and $\cR(x) = 0$ one obtains the vanilla least-squares problem which can be rewritten in vector notation as

\[
\underset{x \in \R^n}{\mathrm{min.}} \; \|W x - Y\|_2^2 ,
\]

where $W \in \R^{m \times n}$ is the matrix with $w_i^{\top}$ on the $i^{th}$ row and $Y =(y_1, \hdots, y_n)^{\top}$.
With $\cR(x) = \|x\|_2^2$ one obtains the ridge regression problem, while with $\cR(x) = \|x\|_1$ this is the LASSO problem \cite{Tib96}.

Our last two examples are of a slightly different flavor. In particular the design variable $x$ is now best viewed as a matrix, and thus we denote it by a capital letter $X$. The sparse inverse covariance estimation problem can be written as follows, given some empirical covariance matrix $Y$,
\begin{align*}
& \mathrm{min.} \; \mathrm{Tr}(X Y) - \mathrm{logdet}(X) + \lambda \|X\|_1 \\
& \text{s.t.} \; X \in \R^{n \times n}, X^{\top} = X, X \succeq 0 .
\end{align*}
Intuitively the above problem is simply a regularized maximum likelihood estimator (under a Gaussian assumption). 

Finally we introduce the convex version of the matrix completion problem. Here our data set consists of observations of some of the entries of an unknown matrix $Y$, and we want to ``complete" the unobserved entries of $Y$ in such a way that the resulting matrix is ``simple" (in the sense that it has low rank). After some massaging (see \cite{CR09}) the (convex) matrix completion problem can be formulated as follows:
\begin{align*}
& \mathrm{min.} \; \mathrm{Tr}(X) \\
& \text{s.t.} \; X \in \R^{n \times n}, X^{\top} = X, X \succeq 0, X_{i,j} = Y_{i,j} \; \text{for} \; (i,j) \in \Omega ,
\end{align*}
where $\Omega \subset [n]^2$ and $(Y_{i,j})_{(i,j) \in \Omega}$ are given.

## Results

<div class="filter-row" data-filter-root><button class="filter-chip active" data-filter-status="all" type="button">All</button><button class="filter-chip" data-filter-status="proved" type="button">Proved</button><button class="filter-chip" data-filter-status="partial" type="button">Partial</button><button class="filter-chip" data-filter-status="pending" type="button">Pending</button><button class="filter-chip" data-filter-status="failed" type="button">Failed</button></div>

| Status | Result | Name | Lean |
|--------|--------|------|------|
