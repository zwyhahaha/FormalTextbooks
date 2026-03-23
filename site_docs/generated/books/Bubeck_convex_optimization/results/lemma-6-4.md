# Lemma 6.4

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.3](../sections/section-6-3-sum-of-smooth-and-strongly-convex-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Lemma**

Let $f_1, \hdots f_m$ be $\beta$-smooth convex functions on $\R^n$, and $i$ be a random variable uniformly distributed in $[m]$. Then

\[
\E \| \nabla f_i(x) - \nabla f_i(x^*) \|_2^2 \leq 2 \beta (f(x) - f(x^*)) .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 6.4 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma64.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma64.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_03_sum_of_smooth_and_strongly_convex_functi.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_03_sum_of_smooth_and_strongly_convex_functi.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 6.3](./theorem-6-3.md)
- Next: [Theorem 6.5](./theorem-6-5.md)
