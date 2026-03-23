# Lemma 6.12

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.6](../sections/section-6-6-convex-relaxation-and-randomized-rounding.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Lemma**

Let $\xi \sim \mathcal{N}(0,\Sigma)$ with $\Sigma_{i,i}=1$ for $i \in [n]$, and $\zeta = \mathrm{sign}(\xi)$. Then

\[
\E \ \zeta_i \zeta_j = \frac{2}{\pi} \mathrm{arcsin} \left(\Sigma_{i,j}\right) .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 6.12 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma612.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma612.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_06_convex_relaxation_and_randomized_roundin.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_06_convex_relaxation_and_randomized_roundin.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 6.10](./theorem-6-10.md)
- Next: [Theorem 6.11](./theorem-6-11.md)
