# Theorem 6.2

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.1](../sections/section-6-1-non-smooth-stochastic-optimization.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Theorem**

Let $f$ be $\alpha$-strongly convex, and assume that the stochastic oracle is such that $\E \|\tg(x)\|_*^2 \leq B^2$. Then SGD with $\eta_s = \frac{2}{\alpha (s+1)}$ satisfies

\[
f \left(\sum_{s=1}^t \frac{2 s}{t(t+1)} x_s \right) - f(x^*) \leq \frac{2 B^2}{\alpha (t+1)} .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 6.2 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem62.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem62.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_01_non_smooth_stochastic_optimization.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_01_non_smooth_stochastic_optimization.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 6.1](./theorem-6-1.md)
- Next: [Theorem 6.3](./theorem-6-3.md)
