# Chapter 3 — Dimension-free convex optimization

## Section 3.0 — Dimension-free convex optimization

### [Lemma 3.1](../results/lemma-3-1.md)

**Lemma**

Let $x \in \cX$ and $y \in \R^n$, then

\[
(\Pi_{\cX}(y) - x)^{\top} (\Pi_{\cX}(y) - y) \leq 0 ,
\]

which also implies $\|\Pi_{\cX}(y) - x\|^2 + \|y - \Pi_{\cX}(y)\|^2 \leq \|y - x\|^2$.

\clip (0.4,-0.4) rectangle (-1.2,1.2);
\draw[rotate=30, very thick] (0,0) ellipse (0.5 and 0.7);
\node [tokens=1] (noeud1) at (-0.45,-0.1) [label=right:{$x$}] {};
\node [tokens=1] (noeud2) at (-0.6, 0.8) [label=above left:{$y$}] {};
\draw[<->, thick] (noeud1) -- (noeud2) node[midway, below left] {$\|y - x \|$};
\node [tokens=1] (noeud3) at (-60:-0.7) [label=below right:{$\Pi_{\cX}(y)$}] {};
\draw[<->, thick] (noeud2) -- (noeud3) node[midway, above right] {$\|y - \Pi_{\cX}(y) \|$};
\draw[<->, thick] (noeud1) -- (noeud3) node[midway, right] {$\|\Pi_{\cX}(y) - x\|$};
\node at (0.15,-0.2) {$\cX$};

\caption{Illustration of Lemma \ref{lem:todonow}.}

Unless specified otherwise all the proofs in this chapter are taken from \cite{Nes04} (with slight simplification in some cases).

## Section 3.1 — Projected subgradient descent for Lipschitz functions

### [Theorem 3.2](../results/theorem-3-2.md)

**Theorem**

The projected subgradient descent method with $\eta = \frac{R}{L \sqrt{t}}$ satisfies 

\[
f\left(\frac{1}{t} \sum_{s=1}^t x_s\right) - f(x^*) \leq \frac{R L}{\sqrt{t}} .
\]

## Section 3.2 — Gradient descent for smooth functions

### [Theorem 3.3](../results/theorem-3-3.md)

**Theorem**

Let $f$ be convex and $\beta$-smooth on $\R^n$. 
Then gradient descent with $\eta = \frac{1}{\beta}$ satisfies

\[
f(x_t) - f(x^*) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t-1} .
\]

Before embarking on the proof we state a few properties of smooth convex functions.

### [Lemma 3.4](../results/lemma-3-4.md)

**Lemma**

Let $f$ be a $\beta$-smooth function on $\R^n$. Then for any $x, y \in \R^n$, one has

\[
|f(x) - f(y) - \nabla f(y)^{\top} (x - y)| \leq \frac{\beta}{2} \|x - y\|^2 .
\]

### [Lemma 3.5](../results/lemma-3-5.md)

**Lemma**

Let $f$ be such that \eqref{eq:defaltsmooth} holds true. Then for any $x, y \in \R^n$, one has

\[
f(x) - f(y) \leq \nabla f(x)^{\top} (x - y) - \frac{1}{2 \beta} \|\nabla f(x) - \nabla f(y)\|^2 .
\]

## Section 3.2.1 — The constrained case

### [Lemma 3.6](../results/lemma-3-6.md)

**Lemma**

Let $x, y \in \cX$, $x^+ = \Pi_{\cX}\left(x - \frac{1}{\beta} \nabla f(x)\right)$, and $g_{\cX}(x) = \beta(x - x^+)$. Then the following holds true:

\[
f(x^+) - f(y) \leq g_{\cX}(x)^{\top}(x-y) - \frac{1}{2 \beta} \|g_{\cX}(x)\|^2 .
\]

### [Theorem 3.7](../results/theorem-3-7.md)

**Theorem**

Let $f$ be convex and $\beta$-smooth on $\cX$. Then projected gradient descent with $\eta = \frac{1}{\beta}$ satisfies

\[
f(x_t) - f(x^*) \leq \frac{3 \beta \|x_1 - x^*\|^2 + f(x_1) - f(x^*)}{t} .
\]

## Section 3.3 — Conditional gradient descent, aka Frank-Wolfe

### [Theorem 3.8](../results/theorem-3-8.md)

**Theorem**

Let $f$ be a convex and $\beta$-smooth function w.r.t. some norm $\|\cdot\|$, $R = \sup_{x, y \in \mathcal{X}} \|x - y\|$, and $\gamma_s = \frac{2}{s+1}$ for $s \geq 1$. Then for any $t \geq 2$, one has

\[
f(x_t) - f(x^*) \leq \frac{2 \beta R^2}{t+1} .
\]

## Section 3.4.1 — Strongly convex and Lipschitz functions

### [Theorem 3.9](../results/theorem-3-9.md)

**Theorem**

Let $f$ be $\alpha$-strongly convex and $L$-Lipschitz on $\cX$. Then projected subgradient descent with $\eta_s = \frac{2}{\alpha (s+1)}$ satisfies

\[
f \left(\sum_{s=1}^t \frac{2 s}{t(t+1)} x_s \right) - f(x^*) \leq \frac{2 L^2}{\alpha (t+1)} .
\]

## Section 3.4.2 — Strongly convex and smooth functions

### [Theorem 3.10](../results/theorem-3-10.md)

**Theorem**

Let $f$ be $\alpha$-strongly convex and $\beta$-smooth on $\cX$. Then projected gradient descent with $\eta = \frac{1}{\beta}$ satisfies for $t \geq 0$,

\[
\|x_{t+1} - x^*\|^2 \leq \exp\left( - \frac{t}{\kappa} \right) \|x_1 - x^*\|^2 .
\]

### [Lemma 3.11](../results/lemma-3-11.md)

**Lemma**

Let $f$ be $\beta$-smooth and $\alpha$-strongly convex on $\R^n$. Then for all $x, y \in \mathbb{R}^n$, one has

\[
(\nabla f(x) - \nabla f(y))^{\top} (x - y) \geq \frac{\alpha \beta}{\beta + \alpha} \|x-y\|^2 + \frac{1}{\beta + \alpha} \|\nabla f(x) - \nabla f(y)\|^2 .
\]

### [Theorem 3.12](../results/theorem-3-12.md)

**Theorem**

Let $f$ be $\beta$-smooth and $\alpha$-strongly convex on $\R^n$. Then gradient descent with $\eta = \frac{2}{\alpha + \beta}$ satisfies

\[
f(x_{t+1}) - f(x^*) \leq \frac{\beta}{2} \exp\left( - \frac{4 t}{\kappa+1} \right) \|x_1 - x^*\|^2 .
\]

## Section 3.5 — Lower bounds

### [Theorem 3.13](../results/theorem-3-13.md)

**Theorem**

Let $t \leq n$, $L, R >0$. There exists a convex and $L$-Lipschitz function $f$ such that for any black-box procedure satisfying \eqref{eq:ass1},

\[
\min_{1 \leq s \leq t} f(x_s) - \min_{x \in \mB_2(R)} f(x) \geq  \frac{R L}{2 (1 + \sqrt{t})} .
\]

There also exists an $\alpha$-strongly convex and $L$-lipschitz function $f$ such that for any black-box procedure satisfying \eqref{eq:ass1},

\[
\min_{1 \leq s \leq t} f(x_s) - \min_{x \in \mB_2\left(\frac{L}{2 \alpha}\right)} f(x) \geq  \frac{L^2}{8 \alpha t} .
\]

Note that the above result is restricted to a number of iterations smaller than the dimension, that is $t \leq n$. This restriction is of course necessary to obtain lower bounds polynomial in $1/t$: as we saw in Chapter \ref{finitedim} one can always obtain an exponential rate of convergence when the number of calls to the oracle is larger than the dimension.

### [Theorem 3.14](../results/theorem-3-14.md)

**Theorem**

Let $t \leq (n-1)/2$, $\beta >0$. There exists a $\beta$-smooth convex function $f$ such that for any black-box procedure satisfying \eqref{eq:ass1},

\[
\min_{1 \leq s \leq t} f(x_s) - f(x^*) \geq  \frac{3 \beta}{32} \frac{\|x_1 - x^*\|^2}{(t+1)^2} .
\]

### [Theorem 3.15](../results/theorem-3-15.md)

**Theorem**

Let $\kappa > 1$. There exists a $\beta$-smooth and $\alpha$-strongly convex function $f: \ell_2 \rightarrow \mathbb{R}$ with $\kappa = \beta / \alpha$ such that for any $t \geq 1$ and any black-box procedure satisfying \eqref{eq:ass1} one has

\[
f(x_t) - f(x^*) \geq  \frac{\alpha}{2}  \left(\frac{\sqrt{\kappa} - 1}{\sqrt{\kappa}+1}\right)^{2 (t-1)} \|x_1 - x^*\|^2 .
\]

Note that for large values of the condition number $\kappa$ one has 

\[
\left(\frac{\sqrt{\kappa} - 1}{\sqrt{\kappa}+1}\right)^{2 (t-1)} \approx \exp\left(- \frac{4 (t-1)}{\sqrt{\kappa}} \right) .
\]

## Section 3.6.2 — Acceleration

### [Lemma 3.16](../results/lemma-3-16.md)

**Lemma**

Let $a \in \R^n$ and $\epsilon \in (0,1), g \in \R_+$. Assume that $\|a\| \geq g$. Then there exists $c \in \R^n$ such that for any $\delta \geq 0$,

\[
\mB(0,1 - \epsilon g^2 - \delta) \cap \mB(a, g^2(1-\epsilon) - \delta) \subset \mB\left(c, 1 - \sqrt{\epsilon} - \delta \right) .
\]

## Section 3.6.3 — The geometric descent method

### [Theorem 3.17](../results/theorem-3-17.md)

**Theorem**

For any $t \geq 0$, one has $x^* \in \mB(c_t, R_t^2)$, $R_{t+1}^2 \leq \left(1 - \frac{1}{\sqrt{\kappa}}\right) R_t^2$, and thus

\[
\|x^* - c_t\|^2 \leq \left(1 - \frac{1}{\sqrt{\kappa}}\right)^t R_0^2 .
\]

## Section 3.7.1 — The smooth and strongly convex case

### [Theorem 3.18](../results/theorem-3-18.md)

**Theorem**

Let $f$ be $\alpha$-strongly convex and $\beta$-smooth, then Nesterov's accelerated gradient descent satisfies

\[
f(y_t) - f(x^*) \leq \frac{\alpha + \beta}{2} \|x_1 - x^*\|^2 \exp\left(- \frac{t-1}{\sqrt{\kappa}} \right).
\]

## Section 3.7.2 — The smooth case

### [Theorem 3.19](../results/theorem-3-19.md)

**Theorem**

Let $f$ be a convex and $\beta$-smooth function, then Nesterov's accelerated gradient descent satisfies

\[
f(y_t) - f(x^*) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t^2} .
\]

We follow here the proof of \cite{BT09}. We also refer to \cite{Tse08} for a proof with simpler step-sizes.
