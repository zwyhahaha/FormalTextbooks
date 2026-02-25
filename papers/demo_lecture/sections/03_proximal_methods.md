---
paper: "demo_lecture"
section: 3
title: "Proximal Methods"
---

# Proximal Methods

The proximal operator of $g$ is defined as:
$$\text{prox}_{\lambda g}(v) = \arg\min_x \left\{ g(x) + \frac{1}{2\lambda}\|x - v\|^2 \right\}$$

**Theorem 3.1** (Proximal Gradient Convergence): For $f + g$ with $f$ smooth and $g$ convex,
proximal gradient with step size $\alpha = 1/L$ satisfies the same $O(1/k)$ rate.
