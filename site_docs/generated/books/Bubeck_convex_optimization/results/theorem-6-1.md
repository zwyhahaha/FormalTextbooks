# Theorem 6.1

[Bubeck Convex Optimization](../index.md) / [Chapter 6](../chapters/chapter-6.md) / [Section 6.1](../sections/section-6-1-non-smooth-stochastic-optimization.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-low">Low</span> Queue the randomness chapter behind the deterministic optimization core while keeping its theorem inventory visible and searchable.

## Informal Statement

**Theorem**

Let $\Phi$ be a mirror map $1$-strongly convex on $\mathcal{X} \cap \mathcal{D}$ with respect to $\|\cdot\|$, and
let $R^2 = \sup_{x \in \mathcal{X} \cap \mathcal{D}} \Phi(x) - \Phi(x_1)$. Let $f$ be convex. Furthermore assume that the stochastic oracle is such that $\E \|\tg(x)\|_*^2 \leq B^2$. Then S-MD with $\eta = \frac{R}{B} \sqrt{\frac{2}{t}}$ satisfies

\[
\E f\bigg(\frac{1}{t} \sum_{s=1}^t x_s \bigg) - \min_{x \in \mathcal{X}} f(x) \leq R B \sqrt{\frac{2}{t}} .
\]

Similarly, in the Euclidean and strongly convex case, one can directly generalize Theorem \ref{th:LJSB12}. Precisely we consider stochastic gradient descent (SGD), that is S-MD with $\Phi(x) = \frac12 \|x\|_2^2$, with time-varying step size $(\eta_t)_{t \geq 1}$, that is

\[
x_{t+1} = \Pi_{\cX}(x_t - \eta_t \tg(x_t)) .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 6.1 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem61.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem61.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/06_01_non_smooth_stochastic_optimization.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/06_01_non_smooth_stochastic_optimization.md) |

## Dependencies

- Randomized algorithms should come after the deterministic first-order method templates are stabilized.

## Chapter Blockers

- The chapter depends on stochastic and probabilistic patterns that are not yet standardized in the repository.

## Nearby Results

- Previous: [Theorem 5.9](./theorem-5-9.md)
- Next: [Theorem 6.2](./theorem-6-2.md)
