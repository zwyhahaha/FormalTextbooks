# Theorem 3.17

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.6.3](../sections/section-3-6-3-the-geometric-descent-method.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

For any $t \geq 0$, one has $x^* \in \mB(c_t, R_t^2)$, $R_{t+1}^2 \leq \left(1 - \frac{1}{\sqrt{\kappa}}\right) R_t^2$, and thus

\[
\|x^* - c_t\|^2 \leq \left(1 - \frac{1}{\sqrt{\kappa}}\right)^t R_0^2 .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.17 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem317.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem317.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_06_03_the_geometric_descent_method.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_06_03_the_geometric_descent_method.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Lemma 3.16](./lemma-3-16.md)
- Next: [Theorem 3.18](./theorem-3-18.md)
