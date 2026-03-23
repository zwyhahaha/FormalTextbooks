# Lemma 2.8

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.3.4](../sections/section-2-3-4-constraints-and-the-volumetric-barrier.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Lemma**

One has

\sqrt{1- \sigma_{m+1}(x)} \ \tilde{\lambda} (x) \leq \|\nabla {v}(x)\|_{Q(x)^{-1}} + \sigma_{m+1}(x) + \sqrt{\frac{\sigma_{m+1}^3(x)}{\min_{i \in [m]} \sigma_i(x)}} .

Furthermore if $\tilde{\sigma}_{m+1}(x) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(x)$ then one also has

\lambda(x) \leq  \|\nabla \tilde{v}(x)\|_{Q(x)^{-1}} + \frac{2 \ \tilde{\sigma}_{m+1}(x)}{1 - \tilde{\sigma}_{m+1}(x)} .

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 2.8 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma28.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma28.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Lemma 2.5](./lemma-2-5.md)
- Next: [Theorem 2.6](./theorem-2-6.md)
