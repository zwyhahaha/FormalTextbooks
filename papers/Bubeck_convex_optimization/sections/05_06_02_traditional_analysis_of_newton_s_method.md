---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 6
section_title: Interior point methods
subsection: 2
subsection_title: Traditional analysis of Newton's method
section_id: 5.6.2
tex_label: sec:tradanalysisNM
theorems:
- id: Theorem 5.3
  label: ''
  tex_label: th:NM
lean_files:
- id: Theorem 5.3
  path: proofs/Bubeck_convex_optimization/Theorem53.lean
  status: pending
---

\subsection{Traditional analysis of Newton's method} \label{sec:tradanalysisNM}
We start by describing Newton's method together with its standard analysis showing the quadratic convergence rate when initialized close enough to the optimum. In this subsection we denote $\|\cdot\|$ for both the Euclidean norm on $\R^n$ and the operator norm on matrices (in particular $\|A x\| \leq \|A\| \cdot \|x\|$).

Let $f: \R^n \rightarrow \R$ be a $C^2$ function. 

Using a Taylor's expansion of $f$ around $x$ one obtains
$$f(x+h) = f(x) + h^{\top} \nabla f(x) + \frac12 h^{\top} \nabla^2 f(x) h + o(\|h\|^2) .$$
Thus, starting at $x$, in order to minimize $f$ it seems natural to move in the direction $h$ that minimizes 
$$h^{\top} \nabla f(x) + \frac12 h^{\top} \nabla f^2(x) h .$$
If $\nabla^2 f(x)$ is positive definite then the solution to this problem is given by $h = - [\nabla^2 f(x)]^{-1} \nabla f(x)$. Newton's method simply iterates this idea: starting at some point $x_0 \in \R^n$, it iterates for $k \geq 0$ the following equation:
$$x_{k+1} = x_k  - [\nabla^2 f(x_k)]^{-1} \nabla f(x_k) .$$
While this method can have an arbitrarily bad behavior in general, if started close enough to a strict local minimum of $f$, it can have a very fast convergence:

**Theorem**

\label{th:NM}
Assume that $f$ has a Lipschitz Hessian, that is $\| \nabla^2 f(x) - \nabla^2 f(y) \| \leq M \|x - y\|$. Let $x^*$ be local minimum of $f$ with strictly positive Hessian, that is $\nabla^2 f(x^*) \succeq \mu \mI_n$, $\mu > 0$. Suppose that the initial starting point $x_0$ of Newton's method is such that
$$\|x_0 - x^*\| \leq \frac{\mu}{2 M} .$$
Then Newton's method is well-defined and converges to $x^*$ at a quadratic rate:
$$\|x_{k+1} - x^*\| \leq \frac{M}{\mu} \|x_k - x^*\|^2.$$

*Proof.*

We use the following simple formula, for $x, h \in \R^n$,
$$\int_0^1 \nabla^2 f(x + s h) \ h \ ds = \nabla f(x+h) - \nabla f(x) .$$
Now note that $\nabla f(x^*) = 0$, and thus with the above formula one obtains
$$\nabla f(x_k) = \int_0^1 \nabla^2 f(x^* + s (x_k - x^*)) \ (x_k - x^*) \ ds ,$$
which allows us to write:
\begin{align*}
& x_{k+1} - x^* \\
& = x_k - x^* - [\nabla^2 f(x_k)]^{-1} \nabla f(x_k) \\
& = x_k - x^* - [\nabla^2 f(x_k)]^{-1} \int_0^1 \nabla^2 f(x^* + s (x_k - x^*)) \ (x_k - x^*) \ ds \\
& = [\nabla^2 f(x_k)]^{-1} \int_0^1 [\nabla^2 f (x_k) - \nabla^2 f(x^* + s (x_k - x^*)) ] \ (x_k - x^*) \ ds .
\end{align*}
In particular one has
\begin{align*}
& \|x_{k+1} - x^*\| \\
& \leq \|[\nabla^2 f(x_k)]^{-1}\| \\
& \times \left( \int_0^1 \| \nabla^2 f (x_k) - \nabla^2 f(x^* + s (x_k - x^*)) \| \ ds \right) \|x_k - x^* \|.
\end{align*}
Using the Lipschitz property of the Hessian one immediately obtains that 
$$\left( \int_0^1 \| \nabla^2 f (x_k) - \nabla^2 f(x^* + s (x_k - x^*)) \| \ ds \right) \leq \frac{M}{2} \|x_k - x^*\| .$$
Using again the Lipschitz property of the Hessian (note that $\|A - B\| \leq s \Leftrightarrow s \mI_n \succeq A - B \succeq - s \mI_n$), the hypothesis on $x^*$, and an induction hypothesis that $\|x_k - x^*\| \leq \frac{\mu}{2M}$, one has
$$\nabla^2 f(x_k) \succeq \nabla^2 f(x^*) - M \|x_k - x^*\| \mI_n \succeq (\mu - M \|x_k - x^*\|) \mI_n \succeq \frac{\mu}{2} \mI_n ,$$
which concludes the proof.