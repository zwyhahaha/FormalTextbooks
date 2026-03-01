---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 6
section_title: Geometric descent
subsection: 3
subsection_title: The geometric descent method
section_id: 3.6.3
tex_label: sec:GeoDmethod
theorems:
- id: Theorem 3.16
  label: ''
  tex_label: thm:main
lean_files:
- id: Theorem 3.16
  path: proofs/Bubeck_convex_optimization/Theorem316.lean
  status: pending
---

\subsection{The geometric descent method} \label{sec:GeoDmethod}
Let $x_0 \in \R^n$, $c_0 = x_0^{++}$, and $R_0^2 = \left(1 - \frac{1}{\kappa}\right)\frac{\|\nabla f(x_0)\|^2}{\alpha^2}$. For any $t \geq 0$ let
$$x_{t+1} = \argmin_{x \in \left\{(1-\lambda) c_t + \lambda x_t^+, \ \lambda \in \R \right\}} f(x) ,$$
and $c_{t+1}$ (respectively $R^2_{t+1}$) be the center (respectively the squared radius) of the ball given by (the proof of) Lemma \ref{lem:geom} which contains
$$\mB\left(c_t, R_t^2 - \frac{\|\nabla f(x_{t+1})\|^2}{\alpha^2 \kappa}\right) \cap \mB\left(x_{t+1}^{++}, \frac{\|\nabla f(x_{t+1})\|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right) \right).$$
Formulas for $c_{t+1}$ and $R^2_{t+1}$ are given at the end of this section.

**Theorem**
\label{thm:main}
For any $t \geq 0$, one has $x^* \in \mB(c_t, R_t^2)$, $R_{t+1}^2 \leq \left(1 - \frac{1}{\sqrt{\kappa}}\right) R_t^2$, and thus
$$\|x^* - c_t\|^2 \leq \left(1 - \frac{1}{\sqrt{\kappa}}\right)^t R_0^2 .$$

*Proof.*
 
We will prove a stronger claim by induction that for each $t\geq 0$, one has
$$x^* \in \mB\left(c_t, R_t^2 - \frac{2}{\alpha} \left(f(x_t^+) - f(x^*)\right)\right) .$$
The case $t=0$ follows immediately by \eqref{eq:ball2}. Let us assume that the above display is true for some $t \geq 0$. Then using $f(x_{t+1}^+) \leq f(x_{t+1}) - \frac{1}{2\beta} \|\nabla f(x_{t+1})\|^2 \leq f(x_t^+) - \frac{1}{2\beta} \|\nabla f(x_{t+1})\|^2 ,$
one gets
$$x^* \in \mB\left(c_t, R_t^2 - \frac{\|\nabla f(x_{t+1})\|^2}{\alpha^2 \kappa} - \frac{2}{\alpha} \left(f(x_{t+1}^+) - f(x^*)\right) \right) .$$
Furthermore by \eqref{eq:ball2} one also has
$$\mB\left(x_{t+1}^{++}, \frac{\|\nabla f(x_{t+1})\|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right) - \frac{2}{\alpha} \left(f(x_{t+1}^+) - f(x^*)\right) \right).$$
Thus it only remains to observe that the squared radius of the ball given by Lemma \ref{lem:geom} which encloses the intersection of the two above balls is smaller than $\left(1 - \frac{1}{\sqrt{\kappa}}\right) R_t^2 - \frac{2}{\alpha} (f(x_{t+1}^+) - f(x^*))$.
We apply Lemma~\ref{lem:geom} after moving $c_t$ to the origin and scaling distances by $R_t$. We set $\epsilon =\frac{1}{\kappa}$, $g=\frac{\|\nabla f(x_{t+1})\|}{\alpha}$, $\delta=\frac{2}{\alpha}\left(f(x_{t+1}^+)-f(x^*)\right)$ and $a={x_{t+1}^{++}-c_t}$.  The line search step of the algorithm implies that $\nabla f(x_{t+1})^{\top} (x_{t+1} - c_t) = 0$ and therefore, $\|a\|=\|x_{t+1}^{++} - c_t\| \geq \|\nabla f(x_{t+1})\|/\alpha=g$ and Lemma~\ref{lem:geom} applies to give the result.

One can use the following formulas for $c_{t+1}$ and $R^2_{t+1}$ (they are derived from the proof of Lemma \ref{lem:geom}). If $|\nabla f(x_{t+1})|^2 / \alpha^2 < R_t^2 / 2$ then one can tate $c_{t+1} = x_{t+1}^{++}$ and $R_{t+1}^2 = \frac{|\nabla f(x_{t+1})|^2}{\alpha^2} \left(1 - \frac{1}{\kappa}\right)$. On the other hand if $|\nabla f(x_{t+1})|^2 / \alpha^2 \geq R_t^2 / 2$ then one can tate
\begin{eqnarray*}
c_{t+1} & = & c_t + \frac{R_t^2 + |x_{t+1} - c_t|^2}{2 |x_{t+1}^{++} - c_t|^2} (x_{t+1}^{++} - c_t) , \\
R_{t+1}^2 & = & R_t^2 - \frac{|\nabla f(x_{t+1})|^2}{\alpha^2 \kappa} - \left( \frac{R_t^2 + \|x_{t+1} - c_t\|^2}{2 \|x_{t+1}^{++} - c_t\|}  \right)^2.
\end{eqnarray*}