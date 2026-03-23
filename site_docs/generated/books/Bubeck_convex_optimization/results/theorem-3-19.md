# Theorem 3.19

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.7.2](../sections/section-3-7-2-the-smooth-case.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $f$ be a convex and $\beta$-smooth function, then Nesterov's accelerated gradient descent satisfies

\[
f(y_t) - f(x^*) \leq \frac{2 \beta \|x_1 - x^*\|^2}{t^2} .
\]

We follow here the proof of \cite{BT09}. We also refer to \cite{Tse08} for a proof with simpler step-sizes.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.19 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem319.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem319.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_07_02_the_smooth_case.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_07_02_the_smooth_case.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.18](./theorem-3-18.md)
- Next: [Lemma 4.1](./lemma-4-1.md)
