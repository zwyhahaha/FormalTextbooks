# Lemma 4.1

[Bubeck Convex Optimization](../index.md) / [Chapter 4](../chapters/chapter-4.md) / [Section 4.1](../sections/section-4-1-mirror-maps.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Introduce mirror-descent-era abstractions only after the Chapter 3 first-order patterns are stable and reusable.

## Informal Statement

**Lemma**

Let $x \in \cX \cap \cD$ and $y \in \cD$, then

\[
(\nabla \Phi(\Pi_{\cX}^{\Phi}(y)) - \nabla \Phi(y))^{\top} (\Pi^{\Phi}_{\cX}(y) - x) \leq 0 ,
\]

which also implies 

\[
D_{\Phi}(x, \Pi^{\Phi}_{\cX}(y)) + D_{\Phi}(\Pi^{\Phi}_{\cX}(y), y) \leq D_{\Phi}(x,y) .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 4.1 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma41.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma41.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/04_01_mirror_maps.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/04_01_mirror_maps.md) |

## Dependencies

- Chapter 4 should reuse notation and convergence templates that are established in Chapter 3.

## Chapter Blockers

- The project still needs a stable abstraction boundary for mirror maps and Bregman-style arguments.

## Nearby Results

- Previous: [Theorem 3.19](./theorem-3-19.md)
- Next: [Theorem 4.2](./theorem-4-2.md)
