---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 6
section_title: Geometric descent
subsection: 1
subsection_title: 'Warm-up: a geometric alternative to gradient descent'
section_id: 3.6.1
tex_label: sec:warmup
theorems: []
lean_files: []
---

\subsection{Warm-up: a geometric alternative to gradient descent} \label{sec:warmup}

\draw  (0,0) ellipse (2 and 2);
\draw[dashed]  (4,0) ellipse (4 and 4);
\draw  (4,0) ellipse (3.85 and 3.85);
\draw [|-|] (4,0) -- (4,4) node[pos=0.5, right] {$|g|$};
\draw [|-|] (4,0) -- (7.85,0) node[pos=0.5, above] {$\sqrt{1-\epsilon}\ |g|$};

  \clip (0,0) ellipse (2 and 2);
  \fill[lightgray] (4,0) ellipse (3.85 and 3.85);

\draw (0,0) node[cross=5pt] {};

\draw [|-|] (0,0) -- (-2,0) node[pos=0.4, above] {$1$};
\draw [|-|] (0.64719,0) -- (2.53958,0) node[pos=0.35, above] {$\sqrt{1-\epsilon}$};
\draw[thick]  (0.64719,0) ellipse (1.8924 and 1.8924);

\caption{One ball shrinks.}
\label{fig:one_ball}

We start with some notation. Let $\mB(x,r^2) := \{y \in \R^n : \|y-x\|^2 \leq r^2 \}$ (note that the second argument is the radius squared), and
$$x^+ = x - \frac{1}{\beta} \nabla f(x), \ \text{and} \ x^{++} = x - \frac{1}{\alpha} \nabla f(x) . $$
Rewriting the definition of strong convexity \eqref{eq:defstrongconv} as
\begin{eqnarray*}
& f(y) \geq f(x) + \nabla f(x)^{\top} (y-x) + \frac{\alpha}{2} \|y-x\|^2 \\
& \Leftrightarrow \ \frac{\alpha}{2} \|y - x + \frac{1}{\alpha} \nabla f(x) \|^2 \leq \frac{\|\nabla f(x)\|^2}{2 \alpha} - (f(x) - f(y)),
\end{eqnarray*}
one obtains an enclosing ball for the minimizer of $f$ with the $0^{th}$ and $1^{st}$ order information at $x$:
$$x^* \in \mB\left(x^{++}, \frac{\|\nabla f(x)\|^2}{\alpha^2} - \frac{2}{\alpha} (f(x) - f(x^*)) \right) .$$
Furthermore recall that by smoothness (see \eqref{eq:onestepofgd}) one has $f(x^+) \leq f(x) - \frac{1}{2 \beta} \|\nabla f(x)\|^2$ which allows to *shrink* the above ball by a factor of $1-\frac{1}{\kappa}$ and obtain the following:
 \label{eq:ball2}
x^* \in \mB\left(x^{++}, \frac{\|\nabla f(x)\|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right) - \frac{2}{\alpha} (f(x^+) - f(x^*)) \right) 

This suggests a natural strategy: assuming that one has an enclosing ball $A:=\mB(x,R^2)$ for $x^*$ (obtained from previous steps of the strategy), one can then enclose $x^*$ in a ball $B$ containing the intersection of $\mB(x,R^2)$ and the ball $\mB\left(x^{++}, \frac{\|\nabla f(x)\|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right)\right)$ obtained by \eqref{eq:ball2}. Provided that the radius of $B$ is a fraction of the radius of $A$, one can then iterate the procedure by replacing $A$ by $B$, leading to a linear convergence rate. Evaluating  the rate at which the radius shrinks is an elementary calculation: for any $g \in \R^n$, $\epsilon \in (0,1)$, there exists $x \in \R^n$ such that
$$\mB(0,1) \cap \mB(g, \|g\|^2 (1- \epsilon)) \subset \mB(x, 1-\epsilon) . \quad \quad \text{(Figure \ref{fig:one_ball})}$$
Thus we see that in the strategy described above, the radius squared of the enclosing ball for $x^*$ shrinks by a factor $1 - \frac{1}{\kappa}$ at each iteration, thus matching the rate of convergence of gradient descent (see Theorem \ref{th:gdssc}).