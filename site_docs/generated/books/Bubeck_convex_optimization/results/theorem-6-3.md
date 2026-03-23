# Theorem 6.3

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.2](../sections/section-6-2-smooth-stochastic-optimization-and-mini-batch-sgd.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Theorem**

Let $\Phi$ be a mirror map $1$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ w.r.t. $\|\cdot\|$, and let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$. Let $f$ be convex and $\beta$-smooth w.r.t. $\|\cdot\|$. Furthermore assume that the stochastic oracle is such that $\E \|\nabla f(x) - \tg(x)\|_*^2 \leq \sigma^2$. Then S-MD with stepsize $\frac{1}{\beta + 1/\eta}$ and $\eta = \frac{R}{\sigma} \sqrt{\frac{2}{t}}$ satisfies

\[
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_{s+1} \bigg) - f(x^*) \leq R \sigma \sqrt{\frac{2}{t}} + \frac{\beta R^2}{t} .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 6.3 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem63.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem63.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_02_smooth_stochastic_optimization_and_mini_.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_02_smooth_stochastic_optimization_and_mini_.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 6.2](./theorem-6-2.md)
- Next: [Lemma 6.4](./lemma-6-4.md)
