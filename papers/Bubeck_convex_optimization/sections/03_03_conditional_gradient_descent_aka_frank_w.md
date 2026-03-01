---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 3
section_title: Conditional gradient descent, aka Frank-Wolfe
subsection: null
subsection_title: null
section_id: '3.3'
tex_label: sec:FW
theorems:
- id: Theorem 3.7
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 3.7
  path: proofs/Bubeck_convex_optimization/Theorem37.lean
  status: pending
---

\section{Conditional gradient descent, aka Frank-Wolfe} \label{sec:FW}

We describe now an alternative algorithm to minimize a smooth convex function $f$ over a compact convex set $\mathcal{X}$. The {\em conditional gradient descent}, introduced in \cite{FW56}, performs the following update for $t \geq 1$, where $(\gamma_s)_{s \geq 1}$ is a fixed sequence,

&y_{t} \in \mathrm{argmin}_{y \in \mathcal{X}} \nabla f(x_t)^{\top} y \label{eq:FW1} \\
& x_{t+1} = (1 - \gamma_t) x_t + \gamma_t y_t . \label{eq:FW2}

In words conditional gradient descent makes a step in the steepest descent direction {\em given the constraint set $\cX$}, see Figure \ref{fig:FW} for an illustration. From a computational perspective, a key property of this scheme is that it replaces the projection step of projected gradient descent by a linear optimization over $\cX$, which in some cases can be a much simpler problem. 

\node [tokens=1] (noeud1) at (0.1,-0.1) [label=below right:{$x_t$}] {};
\node [tokens=1] (noeud2) at (-0.38,0.65) [label=above left:{$y_{t}$}] {};
\draw[->, thick] (noeud1) -- (-0.05, 0.4) node[midway, right] {$-\nabla f(x_t)$};
\node [tokens=1] (noeud3) at (-0.065,0.15) [label=below left:{$x_{t+1}$}] {};
\draw[thick, dashed] (noeud1) -- (noeud2) {};
\node at (0.3,-0.55) {$\cX$};
\node (S) [very thick, regular polygon, regular polygon sides=6, draw,
inner sep=40] at (0,0) {};

\caption{Illustration of conditional gradient descent.}
\label{fig:FW}

We now turn to the analysis of this method. A major advantage of conditional gradient descent over projected gradient descent is that the former can adapt to smoothness in an arbitrary norm. Precisely let $f$ be $\beta$-smooth in some norm $\|\cdot\|$, that is $\|\nabla f(x) - \nabla f(y) \|_* \leq \beta \|x-y\|$ where the dual norm $\|\cdot\|_*$ is defined as $\|g\|_* = \sup_{x \in \mathbb{R}^n : \|x\| \leq 1} g^{\top} x$. The following result is extracted from \cite{Jag13} (see also \cite{DH78}).

**Theorem**

Let $f$ be a convex and $\beta$-smooth function w.r.t. some norm $\|\cdot\|$, $R = \sup_{x, y \in \mathcal{X}} \|x - y\|$, and $\gamma_s = \frac{2}{s+1}$ for $s \geq 1$. Then for any $t \geq 2$, one has
$$f(x_t) - f(x^*) \leq \frac{2 \beta R^2}{t+1} .$$

*Proof.*

The following inequalities hold true, using respectively $\beta$-smoothness (it can easily be seen that \eqref{eq:defaltsmooth} holds true for smoothness in an arbitrary norm), the definition of $x_{s+1}$, the definition of $y_s$, and the convexity of $f$:
\begin{eqnarray*}
f(x_{s+1}) - f(x_s) & \leq & \nabla f(x_s)^{\top} (x_{s+1} - x_s) + \frac{\beta}{2} \|x_{s+1} - x_s\|^2 \\
& \leq & \gamma_s \nabla f(x_s)^{\top} (y_{s} - x_s) + \frac{\beta}{2} \gamma_s^2 R^2 \\
& \leq & \gamma_s \nabla f(x_s)^{\top} (x^* - x_s) + \frac{\beta}{2} \gamma_s^2 R^2 \\
& \leq & \gamma_s (f(x^*) - f(x_s)) + \frac{\beta}{2} \gamma_s^2 R^2 .
\end{eqnarray*}
Rewriting this inequality in terms of $\delta_s = f(x_s) - f(x^*)$ one obtains
$$\delta_{s+1} \leq (1 - \gamma_s) \delta_s + \frac{\beta}{2} \gamma_s^2 R^2 .$$
A simple induction using that $\gamma_s = \frac{2}{s+1}$ finishes the proof (note that the initialization is done at step $2$ with the above inequality yielding $\delta_2 \leq \frac{\beta}{2} R^2$).

In addition to being projection-free and ``norm-free", the conditional gradient descent satisfies a perhaps even more important property: it produces {\em sparse iterates}. More precisely consider the situation where $\cX \subset \R^n$ is a polytope, that is the convex hull of a finite set of points (these points are called the vertices of $\cX$). Then Carath\'eodory's theorem states that any point $x \in \cX$ can be written as a convex combination of at most $n+1$ vertices of $\cX$. On the other hand, by definition of the conditional gradient descent, one knows that the $t^{th}$ iterate $x_t$ can be written as a convex combination of $t$ vertices (assuming that $x_1$ is a vertex). Thanks to the dimension-free rate of convergence one is usually interested in the regime where $t \ll n$, and thus we see that the iterates of conditional gradient descent are very sparse in their vertex representation.

We note an interesting corollary of the sparsity property together with the rate of convergence we proved: smooth functions on the simplex $\{x \in \mathbb{R}_+^n : \sum_{i=1}^n x_i = 1\}$ always admit sparse approximate minimizers. More precisely there must exist a point $x$ with only $t$ non-zero coordinates and such that $f(x) - f(x^*) = O(1/t)$. Clearly this is the best one can hope for in general, as it can be seen with the function $f(x) = \|x\|^2_2$ since by Cauchy-Schwarz one has $\|x\|_1 \leq \sqrt{\|x\|_0} \|x\|_2$ which implies on the simplex $\|x\|_2^2 \geq 1 / \|x\|_0$.

Next we describe an application where the three properties of conditional gradient descent (projection-free, norm-free, and sparse iterates) are critical to develop a computationally efficient procedure.