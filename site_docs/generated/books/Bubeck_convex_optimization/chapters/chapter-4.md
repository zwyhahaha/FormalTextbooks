# Chapter 4 — Almost dimension-free convex optimization in non-Euclidean spaces

## Section 4.1 — Mirror maps

### [Lemma 4.1](../results/lemma-4-1.md)

**Lemma**

Let $x \in \cX \cap \cD$ and $y \in \cD$, then

\[
(\nabla \Phi(\Pi_{\cX}^{\Phi}(y)) - \nabla \Phi(y))^{\top} (\Pi^{\Phi}_{\cX}(y) - x) \leq 0 ,
\]

which also implies 

\[
D_{\Phi}(x, \Pi^{\Phi}_{\cX}(y)) + D_{\Phi}(\Pi^{\Phi}_{\cX}(y), y) \leq D_{\Phi}(x,y) .
\]

## Section 4.2 — Mirror descent

### [Theorem 4.2](../results/theorem-4-2.md)

**Theorem**

Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$.
Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $L$-Lipschitz w.r.t. $\|\cdot\|$. Then mirror descent with $\eta = \frac{R}{L} \sqrt{\frac{2 \rho}{t}}$ satisfies

\[
f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x^*) \leq RL \sqrt{\frac{2}{\rho t}} .
\]

## Section 4.4 — Lazy mirror descent, aka Nesterov's dual averaging

### [Theorem 4.3](../results/theorem-4-3.md)

**Theorem**

Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$.
Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $L$-Lipschitz w.r.t. $\|\cdot\|$. Then dual averaging with $\eta = \frac{R}{L} \sqrt{\frac{\rho}{2 t}}$ satisfies

\[
f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x^*) \leq 2 RL \sqrt{\frac{2}{\rho t}} .
\]

## Section 4.5 — Mirror prox

### [Theorem 4.4](../results/theorem-4-4.md)

**Theorem**

Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$. Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $\beta$-smooth w.r.t. $\|\cdot\|$. Then mirror prox with $\eta = \frac{\rho}{\beta}$ satisfies

\[
f\bigg(\frac{1}{t} \sum_{s=1}^t y_{s+1} \bigg) - f(x^*) \leq \frac{\beta R^2}{\rho t} .
\]
