# Theorem 3.15

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.5](../sections/section-3-5-lower-bounds.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $\kappa > 1$. There exists a $\beta$-smooth and $\alpha$-strongly convex function $f: \ell_2 \rightarrow \mathbb{R}$ with $\kappa = \beta / \alpha$ such that for any $t \geq 1$ and any black-box procedure satisfying \eqref{eq:ass1} one has

\[
f(x_t) - f(x^*) \geq  \frac{\alpha}{2}  \left(\frac{\sqrt{\kappa} - 1}{\sqrt{\kappa}+1}\right)^{2 (t-1)} \|x_1 - x^*\|^2 .
\]

Note that for large values of the condition number $\kappa$ one has 

\[
\left(\frac{\sqrt{\kappa} - 1}{\sqrt{\kappa}+1}\right)^{2 (t-1)} \approx \exp\left(- \frac{4 (t-1)}{\sqrt{\kappa}} \right) .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.15 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem315.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem315.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.14](./theorem-3-14.md)
- Next: [Lemma 3.16](./lemma-3-16.md)
