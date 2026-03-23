# Theorem 4.3

[Bubeck Convex Optimization](../index.md) / [Chapter 4](../chapters/chapter-4.md) / [Section 4.4](../sections/section-4-4-lazy-mirror-descent-aka-nesterov-s-dual-averaging.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Introduce mirror-descent-era abstractions only after the Chapter 3 first-order patterns are stable and reusable.

## Informal Statement

**Theorem**

Let $\Phi$ be a mirror map $\rho$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$.
Let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$, and $f$ be convex and $L$-Lipschitz w.r.t. $\|\cdot\|$. Then dual averaging with $\eta = \frac{R}{L} \sqrt{\frac{\rho}{2 t}}$ satisfies

\[
f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - f(x^*) \leq 2 RL \sqrt{\frac{2}{\rho t}} .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 4.3 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem43.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem43.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/04_04_lazy_mirror_descent_aka_nesterov_s_dual_.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/04_04_lazy_mirror_descent_aka_nesterov_s_dual_.md) |

## Dependencies

- Chapter 4 should reuse notation and convergence templates that are established in Chapter 3.

## Chapter Blockers

- The project still needs a stable abstraction boundary for mirror maps and Bregman-style arguments.

## Nearby Results

- Previous: [Theorem 4.2](./theorem-4-2.md)
- Next: [Theorem 4.4](./theorem-4-4.md)
