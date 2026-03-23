# Theorem 6.8

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.4.2](../sections/section-6-4-2-rcd-for-smooth-and-strongly-convex-optimization.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Theorem**

Let $\gamma \geq 0$. Let $f$ be $\alpha$-strongly convex w.r.t. $\|\cdot\|_{[1-\gamma]}$, and such that $u \in \R \mapsto f(x + u e_i)$ is $\beta_i$-smooth for any $i \in [n], x \in \R^n$. Let $\kappa_{\gamma} = \frac{\sum_{i=1}^n \beta_i^{\gamma}}{\alpha}$, then RCD($\gamma$) satisfies

\[
\E f(x_{t+1}) - f(x^*) \leq \left(1 - \frac1{\kappa_{\gamma}}\right)^t (f(x_1) - f(x^*)) .
\]

We use the following elementary lemma.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 6.8 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem68.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem68.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_04_02_rcd_for_smooth_and_strongly_convex_optim.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_04_02_rcd_for_smooth_and_strongly_convex_optim.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Lemma 6.9](./lemma-6-9.md)
- Next: [Theorem 6.10](./theorem-6-10.md)
