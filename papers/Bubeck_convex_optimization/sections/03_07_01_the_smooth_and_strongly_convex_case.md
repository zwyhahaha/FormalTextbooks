---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 7
section_title: Nesterov's accelerated gradient descent
subsection: 1
subsection_title: The smooth and strongly convex case
section_id: 3.7.1
tex_label: ''
theorems:
- id: Theorem 3.18
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 3.18
  path: proofs/Bubeck_convex_optimization/Theorem318.lean
  status: pending
---

\subsection{The smooth and strongly convex case}

Nesterov's accelerated gradient descent, illustrated in Figure \ref{fig:nesterovacc}, can be described as follows: Start at an arbitrary initial point 
$x_1 = y_1$ and then iterate the following equations for $t \geq 1$,
\begin{eqnarray*}
y_{t+1} & = & x_t  - \frac{1}{\beta} \nabla f(x_t) , \\
x_{t+1} & = & \left(1 + \frac{\sqrt{\kappa}-1}{\sqrt{\kappa}+1} \right) y_{t+1} - \frac{\sqrt{\kappa}-1}{\sqrt{\kappa}+1} y_t .
\end{eqnarray*}

\node [tokens=1] (noeud1) at (0.5,1) [label=below right:{$x_s$}] {};
\node [tokens=1] (noeud2) at (1.5,-1) [label=below right:{$y_{s}$}] {};
\node [tokens=1] (noeud3) at (2.5,2) [label=below right:{$y_{s+1}$}] {};
\node [tokens=1] (noeud4) at (2.8,3) [label=above left:{$x_{s+1}$}] {};
\draw[->, thick] (noeud1) -- (noeud3) node[midway, left] {$-\frac{1}{\beta}\nabla f(x_s)$};
\draw[thick, dashed] (noeud2) -- (noeud4) {};
\node [tokens=1] (noeud5) at (4.5,3.3) [label=below right:{$y_{s+2}$}] {};
\node [tokens=1] (noeud6) at (5.3,3.8) [label=right:{$x_{s+2}$}] {};
\draw[->, thick] (noeud4) -- (noeud5) {};
\draw[thick, dashed] (noeud3) -- (noeud6) {};

\caption{Illustration of Nesterov's accelerated gradient descent.}
\label{fig:nesterovacc}

**Theorem**

Let $f$ be $\alpha$-strongly convex and $\beta$-smooth, then Nesterov's accelerated gradient descent satisfies
$$f(y_t) - f(x^*) \leq \frac{\alpha + \beta}{2} \|x_1 - x^*\|^2 \exp\left(- \frac{t-1}{\sqrt{\kappa}} \right).$$

*Proof.*

We define $\alpha$-strongly convex quadratic functions $\Phi_s, s \geq 1$ by induction as follows:

& \Phi_1(x) = f(x_1) + \frac{\alpha}{2} \|x-x_1\|^2 , \notag \\
& \Phi_{s+1}(x) = \left(1 - \frac{1}{\sqrt{\kappa}}\right) \Phi_s(x) \notag \\
& \qquad + \frac{1}{\sqrt{\kappa}} \left(f(x_s) + \nabla f(x_s)^{\top} (x-x_s) + \frac{\alpha}{2} \|x-x_s\|^2 \right). \label{eq:AGD0}

Intuitively $\Phi_s$ becomes a finer and finer approximation (from below) to $f$ in the following sense:
 \label{eq:AGD1}
\Phi_{s+1}(x) \leq f(x) + \left(1 - \frac{1}{\sqrt{\kappa}}\right)^s (\Phi_1(x) - f(x)). 

The above inequality can be proved immediately by induction, using the fact that by $\alpha$-strong convexity one has
$$f(x_s) + \nabla f(x_s)^{\top} (x-x_s) + \frac{\alpha}{2} \|x-x_s\|^2 \leq f(x) .$$
Equation \eqref{eq:AGD1} by itself does not say much, for it to be useful one needs to understand how ``far" below $f$ is $\Phi_s$. The following inequality answers this question:
 \label{eq:AGD2}
f(y_s) \leq \min_{x \in \mathbb{R}^n} \Phi_s(x) . 

The rest of the proof is devoted to showing that \eqref{eq:AGD2} holds true, but first let us see how to combine \eqref{eq:AGD1} and \eqref{eq:AGD2} to obtain the rate given by the theorem (we use that by $\beta$-smoothness one has $f(x) - f(x^*) \leq \frac{\beta}{2} \|x-x^*\|^2$):
\begin{eqnarray*}
f(y_t) - f(x^*) & \leq & \Phi_t(x^*) - f(x^*) \\
& \leq & \left(1 - \frac{1}{\sqrt{\kappa}}\right)^{t-1} (\Phi_1(x^*) - f(x^*)) \\
& \leq & \frac{\alpha + \beta}{2} \|x_1-x^*\|^2 \left(1 - \frac{1}{\sqrt{\kappa}}\right)^{t-1} .
\end{eqnarray*}
We now prove \eqref{eq:AGD2} by induction (note that it is true at $s=1$ since $x_1=y_1$). Let $\Phi_s^* = \min_{x \in \mathbb{R}^n} \Phi_s(x)$. Using the definition of $y_{s+1}$ (and $\beta$-smoothness), convexity, and the induction hypothesis, one gets
\begin{eqnarray*}
f(y_{s+1}) & \leq & f(x_s) - \frac{1}{2 \beta} \| \nabla f(x_s) \|^2 \\
& = & \left(1 - \frac{1}{\sqrt{\kappa}}\right) f(y_s) + \left(1 - \frac{1}{\sqrt{\kappa}}\right)(f(x_s) - f(y_s)) \\
& & + \frac{1}{\sqrt{\kappa}} f(x_s) - \frac{1}{2 \beta} \| \nabla f(x_s) \|^2 \\
& \leq & \left(1 - \frac{1}{\sqrt{\kappa}}\right) \Phi_s^* + \left(1 - \frac{1}{\sqrt{\kappa}}\right) \nabla f(x_s)^{\top} (x_s - y_s) \\
& & + \frac{1}{\sqrt{\kappa}} f(x_s) - \frac{1}{2 \beta} \| \nabla f(x_s) \|^2 .
\end{eqnarray*}
Thus we now have to show that
 
\Phi_{s+1}^* & \geq & \left(1 - \frac{1}{\sqrt{\kappa}}\right) \Phi_s^* + \left(1 - \frac{1}{\sqrt{\kappa}}\right) \nabla f(x_s)^{\top} (x_s - y_s) \notag \\
& & + \frac{1}{\sqrt{\kappa}} f(x_s) - \frac{1}{2 \beta} \| \nabla f(x_s) \|^2 . \label{eq:AGD3}

To prove this inequality we have to understand better the functions $\Phi_s$. First note that $\nabla^2 \Phi_s(x) = \alpha \mathrm{I}_n$ (immediate by induction) and thus $\Phi_s$ has to be of the following form:
$$\Phi_s(x) = \Phi_s^* + \frac{\alpha}{2} \|x - v_s\|^2 ,$$
for some $v_s \in \mathbb{R}^n$. Now observe that by differentiating \eqref{eq:AGD0} and using the above form of $\Phi_s$ one obtains
$$\nabla \Phi_{s+1}(x) = \alpha \left(1 - \frac{1}{\sqrt{\kappa}}\right) (x-v_s) + \frac{1}{\sqrt{\kappa}} \nabla f(x_s) + \frac{\alpha}{\sqrt{\kappa}} (x-x_s) .$$
In particular $\Phi_{s+1}$ is by definition minimized at $v_{s+1}$ which can now be defined by induction using the above identity, precisely:
 \label{eq:AGD4}
v_{s+1} = \left(1 - \frac{1}{\sqrt{\kappa}}\right) v_s + \frac{1}{\sqrt{\kappa}} x_s - \frac{1}{\alpha \sqrt{\kappa}} \nabla f(x_s) .

Using the form of $\Phi_s$ and $\Phi_{s+1}$, as well as the original definition \eqref{eq:AGD0} one gets the following identity by evaluating $\Phi_{s+1}$ at $x_s$:
 
& \Phi_{s+1}^* + \frac{\alpha}{2} \|x_s - v_{s+1}\|^2 \notag \\
& = \left(1 - \frac{1}{\sqrt{\kappa}}\right) \Phi_s^* + \frac{\alpha}{2} \left(1 - \frac{1}{\sqrt{\kappa}}\right) \|x_s - v_s\|^2 + \frac{1}{\sqrt{\kappa}} f(x_s) . \label{eq:AGD5}

Note that thanks to \eqref{eq:AGD4} one has
\begin{eqnarray*}
\|x_s - v_{s+1}\|^2 & = & \left(1 - \frac{1}{\sqrt{\kappa}}\right)^2 \|x_s - v_s\|^2 + \frac{1}{\alpha^2 \kappa} \|\nabla f(x_s)\|^2 \\
& & - \frac{2}{\alpha \sqrt{\kappa}} \left(1 - \frac{1}{\sqrt{\kappa}}\right) \nabla f(x_s)^{\top}(v_s-x_s) ,
\end{eqnarray*}
which combined with \eqref{eq:AGD5} yields
\begin{eqnarray*}
\Phi_{s+1}^* & = & \left(1 - \frac{1}{\sqrt{\kappa}}\right) \Phi_s^* + \frac{1}{\sqrt{\kappa}} f(x_s) + \frac{\alpha}{2 \sqrt{\kappa}} \left(1 - \frac{1}{\sqrt{\kappa}}\right) \|x_s - v_s\|^2 \\
& & \qquad - \frac{1}{2 \beta} \| \nabla f(x_s) \|^2 + \frac{1}{\sqrt{\kappa}} \left(1 - \frac{1}{\sqrt{\kappa}}\right) \nabla f(x_s)^{\top}(v_s-x_s) .
\end{eqnarray*}
Finally we show by induction that $v_s - x_s = \sqrt{\kappa}(x_s - y_s)$, which concludes the proof of \eqref{eq:AGD3} and thus also concludes the proof of the theorem:
\begin{eqnarray*}
v_{s+1} - x_{s+1} & = & \left(1 - \frac{1}{\sqrt{\kappa}}\right) v_s + \frac{1}{\sqrt{\kappa}} x_s - \frac{1}{\alpha \sqrt{\kappa}} \nabla f(x_s) - x_{s+1} \\
& = & \sqrt{\kappa} x_s - (\sqrt{\kappa}-1) y_s - \frac{\sqrt{\kappa}}{\beta} \nabla f(x_s) - x_{s+1} \\
& = & \sqrt{\kappa} y_{s+1} - (\sqrt{\kappa}-1) y_s - x_{s+1} \\
& = & \sqrt{\kappa} (x_{s+1} - y_{s+1}) ,
\end{eqnarray*}
where the first equality comes from \eqref{eq:AGD4}, the second from the induction hypothesis, the third from the definition of $y_{s+1}$ and the last one from the definition of $x_{s+1}$.