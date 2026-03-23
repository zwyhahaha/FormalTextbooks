# Theorem 3.14

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.5](../sections/section-3-5-lower-bounds.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $t \leq (n-1)/2$, $\beta >0$. There exists a $\beta$-smooth convex function $f$ such that for any black-box procedure satisfying \eqref{eq:ass1},

\[
\min_{1 \leq s \leq t} f(x_s) - f(x^*) \geq  \frac{3 \beta}{32} \frac{\|x_1 - x^*\|^2}{(t+1)^2} .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.14 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem314.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem314.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.13](./theorem-3-13.md)
- Next: [Theorem 3.15](./theorem-3-15.md)
