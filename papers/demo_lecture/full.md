# Introduction

This lecture covers convex optimization fundamentals.
We study first-order methods for minimizing convex functions.

# Gradient Descent

Let $f: \mathbb{R}^n \to \mathbb{R}$ be convex and $L$-smooth, i.e., $\nabla f$ is $L$-Lipschitz.

**Theorem 2.1** (Convergence): With step size $\alpha = 1/L$, gradient descent satisfies:
$$f(x_k) - f^* \leq \frac{\|x_0 - x^*\|^2}{2\alpha k}$$

**Proof**: By $L$-smoothness, we have $f(x_{k+1}) \leq f(x_k) - \frac{1}{2L}\|\nabla f(x_k)\|^2$.
Summing and using monotonicity gives the $O(1/k)$ rate. $\square$

# Proximal Methods

The proximal operator of $g$ is defined as:
$$\text{prox}_{\lambda g}(v) = \arg\min_x \left\{ g(x) + \frac{1}{2\lambda}\|x - v\|^2 \right\}$$

**Theorem 3.1** (Proximal Gradient Convergence): For $f + g$ with $f$ smooth and $g$ convex,
proximal gradient with step size $\alpha = 1/L$ satisfies the same $O(1/k)$ rate.
