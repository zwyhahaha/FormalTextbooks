---
book: Bubeck_convex_optimization
chapter: 5
chapter_title: Beyond the black-box model
section: 6
section_title: Interior point methods
subsection: 3
subsection_title: Self-concordant functions
section_id: 5.6.3
tex_label: ''
theorems:
- id: Definition 5.4
  label: ''
  tex_label: ''
- id: Definition 5.5
  label: ''
  tex_label: ''
- id: Theorem 5.6
  label: ''
  tex_label: th:NMsc
lean_files:
- id: Definition 5.4
  path: proofs/Bubeck_convex_optimization/Definition54.lean
  status: pending
- id: Definition 5.5
  path: proofs/Bubeck_convex_optimization/Definition55.lean
  status: pending
- id: Theorem 5.6
  path: proofs/Bubeck_convex_optimization/Theorem56.lean
  status: pending
---

\subsection{Self-concordant functions}
Before giving the definition of self-concordant functions let us try to get some insight into the ``geometry" of Newton's method. Let $A$ be a $n \times n$ non-singular matrix. We look at a Newton step on the functions $f: x \mapsto f(x)$ and $\phi: y \mapsto f(A^{-1} y)$, starting respectively from $x$ and $y= A x$, that is:
$$x^+ = x  - [\nabla^2 f(x)]^{-1} \nabla f(x) , \; \text{and} \; y^+ = y  - [\nabla^2 \phi(y)]^{-1} \nabla \phi(y) .$$
By using the following simple formulas
$$\nabla (x \mapsto f(A x) ) =A^{\top} \nabla f(A x) , \; \text{and} \; \nabla^2 (x \mapsto f(A x) ) =A^{\top} \nabla^2 f(A x) A .$$
it is easy to show that
$$y^+ = A x^+ .$$
In other words Newton's method will follow the same trajectory in the ``$x$-space" and in the ``$y$-space" (the image through $A$ of the $x$-space), that is Newton's method is {\em affine invariant}. Observe that this property is not shared by the methods described in Chapter \ref{dimfree} (except for the conditional gradient descent).

The affine invariance of Newton's method casts some concerns on the assumptions of the analysis in Section \ref{sec:tradanalysisNM}. Indeed the assumptions are all in terms of the canonical inner product in $\R^n$. However we just showed that the method itself does not depend on the choice of the inner product (again this is not true for first order methods). Thus one would like to derive a result similar to Theorem \ref{th:NM} without any reference to a prespecified inner product. The idea of self-concordance is to modify the Lipschitz assumption on the Hessian to achieve this goal.

Assume from now on that $f$ is $C^3$, and let $\nabla^3 f(x) : \R^n \times \R^n \times \R^n \rightarrow \R$ be the third order differential operator. The Lipschitz assumption on the Hessian in Theorem \ref{th:NM} can be written as:
$$\nabla^3 f(x) [h,h,h] \leq M \|h\|_2^3 .$$
The issue is that this inequality depends on the choice of an inner product. More importantly it is easy to see that a convex function which goes to infinity on a compact set simply cannot satisfy the above inequality. A natural idea to try fix these issues is to replace the Euclidean metric on the right hand side by the metric given by the function $f$ itself at $x$, that is:
$$\|h\|_x = \sqrt{ h^{\top} \nabla^2 f(x) h }.$$
Observe that to be clear one should rather use the notation $\|\cdot\|_{x, f}$, but since $f$ will always be clear from the context we stick to $\|\cdot\|_x$.

**Definition**

Let $\mathcal{X}$ be a convex set with non-empty interior, and $f$ a $C^3$ convex function defined on $\inte(\mathcal{X})$. Then $f$ is self-concordant (with constant $M$) if for all $x \in \inte(\mathcal{X}), h \in \R^n$,
$$\nabla^3 f(x) [h,h,h] \leq M \|h\|_x^3 .$$
We say that $f$ is standard self-concordant if $f$ is self-concordant with constant $M=2$.

An easy consequence of the definition is that a self-concordant function is a barrier for the set $\mathcal{X}$, see [Theorem 4.1.4, \cite{Nes04}]. The main example to keep in mind of a standard self-concordant function is $f(x) = - \log x$ for $x > 0$. The next definition will be key in order to describe the region of quadratic convergence for Newton's method on self-concordant functions. 

**Definition**

Let $f$ be a standard self-concordant function on $\mathcal{X}$. For $x \in \mathrm{int}(\mathcal{X})$, we say that $\lambda_f(x) = \|\nabla f(x)\|_x^*$ is the {\em Newton decrement} of $f$ at $x$.

An important inequality is that for $x$ such that $\lambda_f(x) < 1$, and $x^* = \argmin f(x)$, one has
 \label{eq:trucipm3}
\|x - x^*\|_x \leq \frac{\lambda_f(x)}{1 - \lambda_f(x)} ,

see [Equation 4.1.18, \cite{Nes04}]. We state the next theorem without a proof, see also [Theorem 4.1.14, \cite{Nes04}].

**Theorem**
 \label{th:NMsc}
Let $f$ be a standard self-concordant function on $\mathcal{X}$, and $x \in \mathrm{int}(\mathcal{X})$ such that $\lambda_f(x) \leq 1/4$, then
$$\lambda_f\Big(x - [\nabla^2 f(x)]^{-1} \nabla f(x)\Big) \leq 2 \lambda_f(x)^2 .$$

In other words the above theorem states that, if initialized at a point $x_0$ such that $\lambda_f(x_0) \leq 1/4$, then Newton's iterates satisfy $\lambda_f(x_{k+1}) \leq 2 \lambda_f(x_k)^2$. Thus, Newton's region of quadratic convergence for self-concordant functions can be described as a ``Newton decrement ball" $\{x : \lambda_f(x) \leq 1/4\}$. In particular by taking the barrier to be a self-concordant function we have now resolved Step (1) of the plan described in Section \ref{sec:barriermethod}.