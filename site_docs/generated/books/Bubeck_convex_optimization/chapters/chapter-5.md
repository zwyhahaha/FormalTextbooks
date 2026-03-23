# Chapter 5 — Beyond the black-box model

## Section 5.5.2 — Saddle Point Mirror Descent (SP-MD)

### [Theorem 5.1](../results/theorem-5-1.md)

**Theorem**

Assume that $\phi(\cdot, y)$ is $L_{\cX}$-Lipschitz w.r.t. $\|\cdot\|_{\cX}$, that is $\|g_{\cX}(x,y)\|_{\cX}^* \leq L_{\cX}, \forall (x, y) \in \cX \times \cY$. Similarly assume that $\phi(x, \cdot)$ is $L_{\cY}$-Lipschitz w.r.t. $\|\cdot\|_{\cY}$. Then SP-MD with $a= \frac{L_{\cX}}{R_{\cX}}$, $b=\frac{L_{\cY}}{R_{\cY}}$, and $\eta=\sqrt{\frac{2}{t}}$ satisfies

\[
\max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t x_s,y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t y_s \right) \leq (R_{\cX} L_{\cX} + R_{\cY} L_{\cY}) \sqrt{\frac{2}{t}}.
\]

## Section 5.5.3 — Saddle Point Mirror Prox (SP-MP)

### [Theorem 5.2](../results/theorem-5-2.md)

**Theorem**

Assume that $\phi$ is $(\beta_{11}, \beta_{12}, \beta_{22}, \beta_{21})$-smooth. Then SP-MP with $a= \frac{1}{R_{\cX}^2}$, $b=\frac{1}{R_{\cY}^2}$, and 

$\eta= 1 / \left(2 \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right) \right)$
satisfies
\begin{align*}
& \max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t u_{s+1},y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t v_{s+1} \right) \\
& \leq \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right) \frac{4}{t} .
\end{align*}

## Section 5.6.2 — Traditional analysis of Newton's method

### [Theorem 5.3](../results/theorem-5-3.md)

**Theorem**

Assume that $f$ has a Lipschitz Hessian, that is $\| \nabla^2 f(x) - \nabla^2 f(y) \| \leq M \|x - y\|$. Let $x^*$ be local minimum of $f$ with strictly positive Hessian, that is $\nabla^2 f(x^*) \succeq \mu \mI_n$, $\mu > 0$. Suppose that the initial starting point $x_0$ of Newton's method is such that

\[
\|x_0 - x^*\| \leq \frac{\mu}{2 M} .
\]

Then Newton's method is well-defined and converges to $x^*$ at a quadratic rate:

\[
\|x_{k+1} - x^*\| \leq \frac{M}{\mu} \|x_k - x^*\|^2.
\]

## Section 5.6.3 — Self-concordant functions

### [Definition 5.4](../results/definition-5-4.md)

**Definition**

Let $\mathcal{X}$ be a convex set with non-empty interior, and $f$ a $C^3$ convex function defined on $\inte(\mathcal{X})$. Then $f$ is self-concordant (with constant $M$) if for all $x \in \inte(\mathcal{X}), h \in \R^n$,

\[
\nabla^3 f(x) [h,h,h] \leq M \|h\|_x^3 .
\]

We say that $f$ is standard self-concordant if $f$ is self-concordant with constant $M=2$.

An easy consequence of the definition is that a self-concordant function is a barrier for the set $\mathcal{X}$, see [Theorem 4.1.4, \cite{Nes04}]. The main example to keep in mind of a standard self-concordant function is $f(x) = - \log x$ for $x > 0$. The next definition will be key in order to describe the region of quadratic convergence for Newton's method on self-concordant functions.

### [Definition 5.5](../results/definition-5-5.md)

**Definition**

Let $f$ be a standard self-concordant function on $\mathcal{X}$. For $x \in \mathrm{int}(\mathcal{X})$, we say that $\lambda_f(x) = \|\nabla f(x)\|_x^*$ is the {\em Newton decrement} of $f$ at $x$.

An important inequality is that for $x$ such that $\lambda_f(x) < 1$, and $x^* = \argmin f(x)$, one has

\|x - x^*\|_x \leq \frac{\lambda_f(x)}{1 - \lambda_f(x)} ,

see [Equation 4.1.18, \cite{Nes04}]. We state the next theorem without a proof, see also [Theorem 4.1.14, \cite{Nes04}].

### [Theorem 5.6](../results/theorem-5-6.md)

**Theorem**

Let $f$ be a standard self-concordant function on $\mathcal{X}$, and $x \in \mathrm{int}(\mathcal{X})$ such that $\lambda_f(x) \leq 1/4$, then

\[
\lambda_f\Big(x - [\nabla^2 f(x)]^{-1} \nabla f(x)\Big) \leq 2 \lambda_f(x)^2 .
\]

In other words the above theorem states that, if initialized at a point $x_0$ such that $\lambda_f(x_0) \leq 1/4$, then Newton's iterates satisfy $\lambda_f(x_{k+1}) \leq 2 \lambda_f(x_k)^2$. Thus, Newton's region of quadratic convergence for self-concordant functions can be described as a ``Newton decrement ball" $\{x : \lambda_f(x) \leq 1/4\}$. In particular by taking the barrier to be a self-concordant function we have now resolved Step (1) of the plan described in Section \ref{sec:barriermethod}.

## Section 5.6.4 — $\nu$-self-concordant barriers

### [Definition 5.7](../results/definition-5-7.md)

**Definition**

$F$ is a $\nu$-self-concordant barrier if it is a standard self-concordant function, and it is $\frac1{\nu}$-exp-concave.

Again the canonical example is the logarithmic function, $x \mapsto - \log x$, which is a $1$-self-concordant barrier for the set $\R_{+}$. We state the next theorem without a proof (see \cite{BE14} for more on this result).

### [Theorem 5.8](../results/theorem-5-8.md)

**Theorem**

Let $\mathcal{X} \subset \R^n$ be a closed convex set with non-empty interior. There exists $F$ which is a $(c \ n)$-self-concordant barrier for $\mathcal{X}$ (where $c$ is some universal constant).

A key property of $\nu$-self-concordant barriers is the following inequality:

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

## Section 5.6.5 — Path-following scheme

### [Theorem 5.9](../results/theorem-5-9.md)

**Theorem**

The path-following scheme described above satisfies

\[
c^{\top} x_k - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{2 \nu}{t_0} \exp\left( - \frac{k}{1+13\sqrt{\nu}} \right) .
\]
