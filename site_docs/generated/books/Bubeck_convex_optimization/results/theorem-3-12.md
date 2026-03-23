# Theorem 3.12

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.4.2](../sections/section-3-4-2-strongly-convex-and-smooth-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $f$ be $\beta$-smooth and $\alpha$-strongly convex on $\R^n$. Then gradient descent with $\eta = \frac{2}{\alpha + \beta}$ satisfies

\[
f(x_{t+1}) - f(x^*) \leq \frac{\beta}{2} \exp\left( - \frac{4 t}{\kappa+1} \right) \|x_1 - x^*\|^2 .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.12 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem312.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem312.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_04_02_strongly_convex_and_smooth_functions.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_04_02_strongly_convex_and_smooth_functions.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.10](./theorem-3-10.md)
- Next: [Theorem 3.13](./theorem-3-13.md)
