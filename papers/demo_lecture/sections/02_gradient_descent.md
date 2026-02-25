---
paper: "demo_lecture"
section: 2
title: "Gradient Descent"
---

# Gradient Descent

Let $f: \mathbb{R}^n \to \mathbb{R}$ be convex and $L$-smooth, i.e., $\nabla f$ is $L$-Lipschitz.

**Theorem 2.1** (Convergence): With step size $\alpha = 1/L$, gradient descent satisfies:
$$f(x_k) - f^* \leq \frac{\|x_0 - x^*\|^2}{2\alpha k}$$

**Proof**: By $L$-smoothness, we have $f(x_{k+1}) \leq f(x_k) - \frac{1}{2L}\|\nabla f(x_k)\|^2$.
Summing and using monotonicity gives the $O(1/k)$ rate. $\square$

