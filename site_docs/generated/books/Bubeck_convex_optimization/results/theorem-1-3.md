# Theorem 1.3

[Bubeck Convex Optimization](../index.md) / [Chapter 1](../chapters/chapter-1.md) / [Section 1.2](../sections/section-1-2-basic-properties-of-convexity.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Lock down the foundational convex-analysis results so later optimization chapters can reuse standard wrappers instead of restating basic geometry.

## Informal Statement

**Theorem** (Supporting Hyperplane Theorem)

Let $\mathcal{X} \subset \R^n$ be a convex set, and $x_0 \in \partial \mathcal{X}$. Then, there exists $w \in \R^n, w \neq 0$ such that

\[
\forall x \in \mathcal{X}, w^{\top} x \geq w^{\top} x_0.
\]

We introduce now the key notion of {\em subgradients}.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Supporting Hyperplane Theorem |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem13.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem13.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md) |

## Dependencies

- Reuse Mathlib separation theorems and Optlib subgradient lemmas before introducing bespoke wrappers.

## Chapter Blockers

- Statement alignment between the book's notation and Mathlib or Optlib wrappers still needs cleanup.

## Nearby Results

- Previous: [Theorem 1.2](./theorem-1-2.md)
- Next: [Proposition 1.6](./proposition-1-6.md)
