---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 6
section_title: Geometric descent
subsection: 2
subsection_title: Acceleration
section_id: 3.6.2
tex_label: sec:accafterwarmup
theorems:
- id: Lemma 3.16
  label: ''
  tex_label: lem:geom
lean_files:
- id: Lemma 3.16
  path: proofs/Bubeck_convex_optimization/Lemma316.lean
  status: pending
---

\subsection{Acceleration} \label{sec:accafterwarmup}

\draw[dashed]  (0,0) ellipse (2 and 2);
\draw  (0,0) ellipse (1.68 and 1.68);
\draw[dashed]  (4,0) ellipse (4 and 4);
\draw  (4,0) ellipse (3.85 and 3.85);

\draw [|-|] (4,0) -- (7.85,0) node[pos=0.5, above] {$\sqrt{1-\epsilon}\ |g|$};

  \clip (0,0) ellipse (1.68 and 1.68);
  \fill[lightgray] (4,0) ellipse (3.85 and 3.85);

\draw (0,0) node[cross=4pt] {};

\draw [|-|] (0,-3) -- (-1.68,-3) node[pos=0.5, above] {$\sqrt{1-\epsilon |g|^2}$};
\draw [|-|] (0.5,0) -- (2.1044,0) node[pos=0.3, above] {\scriptsize $\sqrt{1-\sqrt{\epsilon}}$};

\draw[thick]  (0.5,0) ellipse (1.6044 and 1.6044);

\caption{Two balls shrink.}
\label{fig:two_ball}

In the argument from the previous section we missed the following opportunity: observe that the ball $A=\mB(x,R^2)$ was obtained by intersections of previous balls of the form given by \eqref{eq:ball2}, and thus the new value $f(x)$ could be used to reduce the radius of those previous balls too (an important caveat is that the value $f(x)$ should be smaller than the values used to build those previous balls). Potentially this could show that the optimum is in fact contained in the ball $\mB\left(x, R^2 - \frac{1}{\kappa} \|\nabla f(x)\|^2\right)$. By taking the intersection with the ball $\mB\left(x^{++}, \frac{\|\nabla f(x)\|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right)\right)$ this would allow to obtain a new ball with radius shrunk by a factor $1- \frac{1}{\sqrt{\kappa}}$ (instead of $1 - \frac{1}{\kappa}$): indeed for any $g \in \R^n$, $\epsilon \in (0,1)$, there exists $x \in \R^n$ such that
$$\mB(0,1 - \epsilon \|g\|^2) \cap \mB(g, \|g\|^2 (1- \epsilon)) \subset \mB(x, 1-\sqrt{\epsilon}) . \quad \quad \text{(Figure \ref{fig:two_ball})}$$
Thus it only remains to deal with the caveat noted above, which we do via a line search. In turns this line search might shift the new ball \eqref{eq:ball2}, and to deal with this we shall need the following strengthening of the above set inclusion (we refer to \cite{BLS15} for a simple proof of this result):

**Lemma**
 \label{lem:geom}
Let $a \in \R^n$ and $\epsilon \in (0,1), g \in \R_+$. Assume that $\|a\| \geq g$. Then there exists $c \in \R^n$ such that for any $\delta \geq 0$,
$$\mB(0,1 - \epsilon g^2 - \delta) \cap \mB(a, g^2(1-\epsilon) - \delta) \subset \mB\left(c, 1 - \sqrt{\epsilon} - \delta \right) .$$