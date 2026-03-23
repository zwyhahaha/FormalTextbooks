# Theorem 6.6

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.4](../sections/section-6-4-random-coordinate-descent.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Theorem**

Let $f$ be convex and $L$-Lipschitz on $\R^n$, then RCD with $\eta = \frac{R}{L} \sqrt{\frac{2}{n t}}$ satisfies

\[
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - \min_{x \in \mathcal{X}} f(x) \leq R L \sqrt{\frac{2 n}{t}} .
\]

Somewhat unsurprisingly RCD requires $n$ times more iterations than gradient descent to obtain the same accuracy. In the next section, we will see that this statement can be greatly improved by taking into account directional smoothness.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 6.6 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem66.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem66.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_04_random_coordinate_descent.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_04_random_coordinate_descent.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 6.5](./theorem-6-5.md)
- Next: [Theorem 6.7](./theorem-6-7.md)
