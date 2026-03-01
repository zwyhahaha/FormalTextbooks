---
book: Bubeck_convex_optimization
chapter: 3
chapter_title: Dimension-free convex optimization
section: 4
section_title: Strong convexity
subsection: 2
subsection_title: Strongly convex and smooth functions
section_id: 3.4.2
tex_label: ''
theorems:
- id: Theorem 3.10
  label: ''
  tex_label: th:gdssc
- id: Lemma 3.11
  label: ''
  tex_label: lem:coercive2
- id: Theorem 3.12
  label: ''
  tex_label: ''
lean_files:
- id: Theorem 3.10
  path: proofs/Bubeck_convex_optimization/Theorem310.lean
  status: pending
- id: Lemma 3.11
  path: proofs/Bubeck_convex_optimization/Lemma311.lean
  status: pending
- id: Theorem 3.12
  path: proofs/Bubeck_convex_optimization/Theorem312.lean
  status: pending
---

\subsection{Strongly convex and smooth functions}
As we will see now, having both strong convexity and smoothness allows for a drastic improvement in the convergence rate. We denote $\kappa= \frac{\beta}{\alpha}$ for the {\em condition number} of $f$. The key observation is that Lemma \ref{lem:smoothconst} can be improved to (with the notation of the lemma):
 \label{eq:improvedstrongsmooth}
f(x^+) - f(y) \leq g_{\cX}(x)^{\top}(x-y) - \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 - \frac{\alpha}{2} \|x-y\|^2 .

**Theorem**
 \label{th:gdssc}
Let $f$ be $\alpha$-strongly convex and $\beta$-smooth on $\cX$. Then projected gradient descent with $\eta = \frac{1}{\beta}$ satisfies for $t \geq 0$,
$$\|x_{t+1} - x^*\|^2 \leq \exp\left( - \frac{t}{\kappa} \right) \|x_1 - x^*\|^2 .$$

*Proof.*

Using \eqref{eq:improvedstrongsmooth} with $y=x^*$ one directly obtains
\begin{eqnarray*}
\|x_{t+1} - x^*\|^2& = & \|x_{t} - \frac{1}{\beta} g_{\cX}(x_t) - x^*\|^2 \\
& = & \|x_{t} - x^*\|^2 - \frac{2}{\beta} g_{\cX}(x_t)^{\top} (x_t - x^*) + \frac{1}{\beta^2} \|g_{\cX}(x_t)\|^2 \\
& \leq & \left(1 - \frac{\alpha}{\beta} \right) \|x_{t} - x^*\|^2 \\
& \leq & \left(1 - \frac{\alpha}{\beta} \right)^t \|x_{1} - x^*\|^2 \\
& \leq & \exp\left( - \frac{t}{\kappa} \right) \|x_1 - x^*\|^2 ,
\end{eqnarray*}
which concludes the proof.

We now show that in the unconstrained case one can improve the rate by a constant factor, precisely one can replace $\kappa$ by $(\kappa+1) / 4$ in the oracle complexity bound by using a larger step size. This is not a spectacular gain but the reasoning is based on an improvement of \eqref{eq:coercive1} which can be of interest by itself. Note that \eqref{eq:coercive1} and the lemma to follow are sometimes referred to as {\em coercivity} of the gradient.

**Lemma**
 \label{lem:coercive2}
Let $f$ be $\beta$-smooth and $\alpha$-strongly convex on $\R^n$. Then for all $x, y \in \mathbb{R}^n$, one has
$$(\nabla f(x) - \nabla f(y))^{\top} (x - y) \geq \frac{\alpha \beta}{\beta + \alpha} \|x-y\|^2 + \frac{1}{\beta + \alpha} \|\nabla f(x) - \nabla f(y)\|^2 .$$

*Proof.*

Let $\phi(x) = f(x) - \frac{\alpha}{2} \|x\|^2$. By definition of $\alpha$-strong convexity one has that $\phi$ is convex. Furthermore one can show that $\phi$ is $(\beta-\alpha)$-smooth by proving \eqref{eq:defaltsmooth} (and using that it implies smoothness). Thus using \eqref{eq:coercive1} one gets
$$(\nabla \phi(x) - \nabla \phi(y))^{\top} (x - y) \geq \frac{1}{\beta - \alpha} \|\nabla \phi(x) - \nabla \phi(y)\|^2 ,$$
which gives the claimed result with straightforward computations. (Note that if $\alpha = \beta$ the smoothness of $\phi$ directly implies that $\nabla f(x) - \nabla f(y) = \alpha (x-y)$ which proves the lemma in this case.)

**Theorem**

Let $f$ be $\beta$-smooth and $\alpha$-strongly convex on $\R^n$. Then gradient descent with $\eta = \frac{2}{\alpha + \beta}$ satisfies
$$f(x_{t+1}) - f(x^*) \leq \frac{\beta}{2} \exp\left( - \frac{4 t}{\kappa+1} \right) \|x_1 - x^*\|^2 .$$

*Proof.*

First note that by $\beta$-smoothness (since $\nabla f(x^*) = 0$) one has
$$f(x_t) - f(x^*) \leq \frac{\beta}{2} \|x_t - x^*\|^2 .$$
Now using Lemma \ref{lem:coercive2} one obtains
\begin{eqnarray*}
\|x_{t+1} - x^*\|^2& = & \|x_{t} - \eta \nabla f(x_{t}) - x^*\|^2 \\
& = & \|x_{t} - x^*\|^2 - 2 \eta \nabla f(x_{t})^{\top} (x_{t} - x^*) + \eta^2 \|\nabla f(x_{t})\|^2 \\
& \leq & \left(1 - 2 \frac{\eta \alpha \beta}{\beta + \alpha}\right)\|x_{t} - x^*\|^2 + \left(\eta^2 - 2 \frac{\eta}{\beta + \alpha}\right) \|\nabla f(x_{t})\|^2 \\
& = & \left(\frac{\kappa - 1}{\kappa+1}\right)^2 \|x_{t} - x^*\|^2 \\
& \leq & \exp\left( - \frac{4 t}{\kappa+1} \right) \|x_1 - x^*\|^2 ,
\end{eqnarray*}
which concludes the proof.