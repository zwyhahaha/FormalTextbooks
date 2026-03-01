---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 6
section_title: Interior point methods
subsection: 4
subsection_title: $\nu$-self-concordant barriers
section_id: 5.6.4
tex_label: ''
theorems:
- id: Definition 5.7
  label: ''
  tex_label: ''
- id: Theorem 5.8
  label: ''
  tex_label: ''
lean_files:
- id: Definition 5.7
  path: proofs/Bubeck_convex_optimization/Definition57.lean
  status: pending
- id: Theorem 5.8
  path: proofs/Bubeck_convex_optimization/Theorem58.lean
  status: pending
---

\subsection{$\nu$-self-concordant barriers}
We deal here with Step (2) of the plan described in Section \ref{sec:barriermethod}. Given Theorem \ref{th:NMsc} we want $t'$ to be as large as possible and such that

 \label{eq:trucipm1}
\lambda_{F_{t'}}(x^*(t) ) \leq 1/4 .

Since the Hessian of $F_{t'}$ is the Hessian of $F$, one has
$$\lambda_{F_{t'}}(x^*(t) ) = \|t' c + \nabla F(x^*(t)) \|_{x^*(t)}^* .$$
Observe that, by first order optimality, one has 

$t c + \nabla F(x^*(t))  = 0,$

which yields

 \label{eq:trucipm11}
\lambda_{F_{t'}}(x^*(t) ) = (t'-t) \|c\|^*_{x^*(t)} .

Thus taking 
 \label{eq:trucipm2}
t' = t + \frac{1}{4 \|c\|^*_{x^*(t)}}
 
immediately yields \eqref{eq:trucipm1}. In particular with the value of $t'$ given in \eqref{eq:trucipm2} the Newton's method on $F_{t'}$ initialized at $x^*(t)$ will converge quadratically fast to $x^*(t')$.

It remains to verify that by iterating \eqref{eq:trucipm2} one obtains a sequence diverging to infinity, and to estimate the rate of growth. Thus one needs to control $\|c\|^*_{x^*(t)} = \frac1{t} \|\nabla F(x^*(t))\|_{x^*(t)}^*$. Luckily there is a natural class of functions for which one can control $\|\nabla F(x)\|_x^*$ uniformly over $x$. This is the set of functions such that
 \label{eq:nu}
\nabla^2 F(x) \succeq \frac1{\nu} \nabla F(x) [\nabla F(x) ]^{\top} .

Indeed in that case one has:
\begin{eqnarray*}
\|\nabla F(x)\|_x^* & = & \sup_{h : h^{\top} \nabla F^2(x) h \leq 1} \nabla F(x)^{\top} h \\
& \leq & \sup_{h : h^{\top} \left( \frac1{\nu} \nabla F(x) [\nabla F(x) ]^{\top} \right) h \leq 1} \nabla F(x)^{\top} h \\
& = & \sqrt{\nu} .
\end{eqnarray*}
Thus a safe choice to increase the penalization parameter is $t' = \left(1 + \frac1{4\sqrt{\nu}}\right) t$. Note that the condition \eqref{eq:nu} can also be written as the fact that the function $F$ is $\frac1{\nu}$-exp-concave, that is $x \mapsto \exp(- \frac1{\nu} F(x))$ is concave. We arrive at the following definition.

**Definition**

$F$ is a $\nu$-self-concordant barrier if it is a standard self-concordant function, and it is $\frac1{\nu}$-exp-concave.

Again the canonical example is the logarithmic function, $x \mapsto - \log x$, which is a $1$-self-concordant barrier for the set $\R_{+}$. We state the next theorem without a proof (see \cite{BE14} for more on this result).

**Theorem**

Let $\mathcal{X} \subset \R^n$ be a closed convex set with non-empty interior. There exists $F$ which is a $(c \ n)$-self-concordant barrier for $\mathcal{X}$ (where $c$ is some universal constant).

A key property of $\nu$-self-concordant barriers is the following inequality:
 \label{eq:key}
c^{\top} x^*(t) - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{\nu}{t} ,

see [Equation (4.2.17), \cite{Nes04}]. More generally using \eqref{eq:key} together with \eqref{eq:trucipm3} one obtains

c^{\top} y- \min_{x \in \mathcal{X}} c^{\top} x & \leq & \frac{\nu}{t} + c^{\top} (y - x^*(t)) \notag \\
& = & \frac{\nu}{t} + \frac{1}{t} (\nabla F_t(y) - \nabla F(y))^{\top} (y - x^*(t)) \notag \\ 
& \leq & \frac{\nu}{t} + \frac{1}{t} \|\nabla F_t(y) - \nabla F(y)\|_y^* \cdot \|y - x^*(t)\|_y \notag \\
& \leq & \frac{\nu}{t} + \frac{1}{t} (\lambda_{F_t}(y) + \sqrt{\nu})\frac{\lambda_{F_t} (y)}{1 - \lambda_{F_t}(y)} \label{eq:trucipm4}

In the next section we describe a precise algorithm based on the ideas we developed above. As we will see one cannot ensure to be exactly on the central path, and thus it is useful to generalize the identity \eqref{eq:trucipm11} for a point $x$ close to the central path. We do this as follows:

\lambda_{F_{t'}}(x) & = & \|t' c + \nabla F(x)\|_x^* \notag \\
& = &  \|(t' / t) (t c + \nabla F(x)) + (1- t'/t) \nabla F(x)\|_x^* \notag \\
& \leq & \frac{t'}{t} \lambda_{F_t}(x) + \left(\frac{t'}{t} - 1\right) \sqrt{\nu} .\label{eq:trucipm12}