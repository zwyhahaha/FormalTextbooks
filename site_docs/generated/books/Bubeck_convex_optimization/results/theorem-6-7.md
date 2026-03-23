# Theorem 6.7

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.4.1](../sections/section-6-4-1-rcd-for-coordinate-smooth-optimization.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Theorem**

Let $f$ be convex and such that $u \in \R \mapsto f(x + u e_i)$ is $\beta_i$-smooth for any $i \in [n], x \in \R^n$. Then RCD($\gamma$) satisfies for $t \geq 2$,

\[
\E f(x_{t}) - f(x^*) \leq \frac{2 R_{1 - \gamma}^2(x_1) \sum_{i=1}^n \beta_i^{\gamma}}{t-1} ,
\]

where

\[
R_{1-\gamma}(x_1) = \sup_{x \in \R^n : f(x) \leq f(x_1)} \|x - x^*\|_{[1-\gamma]} .
\]

Recall from Theorem \ref{th:gdsmooth} that in this context the basic gradient descent attains a rate of $\beta \|x_1 - x^*\|_2^2 / t$ where $\beta \leq \sum_{i=1}^n \beta_i$ (see the discussion above). Thus we see that RCD($1$) greatly improves upon gradient descent for functions where $\beta$ is of order of $\sum_{i=1}^n \beta_i$. Indeed in this case both methods attain the same accuracy after a fixed number of iterations, but the iterations of coordinate descent are potentially much cheaper than the iterations of gradient descent.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 6.7 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem67.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem67.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_04_01_rcd_for_coordinate_smooth_optimization.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_04_01_rcd_for_coordinate_smooth_optimization.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 6.6](./theorem-6-6.md)
- Next: [Lemma 6.9](./lemma-6-9.md)
