# Theorem 2.7

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.3.4](../sections/section-2-3-4-constraints-and-the-volumetric-barrier.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Theorem**

Let $\epsilon := \min_{i \in [m]} \sigma_i(x^*)$, $\delta := \sigma_{m+1}(x^*) / \sqrt{\epsilon}$ and assume that $\frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}} < \frac{2 \sqrt{\epsilon} - \epsilon}{36}$. Then one has

\tilde{v}(\tilde{x}^*) - v(x^*) \geq \frac{1}{2} \log(1+\delta \sqrt{\epsilon}) - 2  \frac{\left(\delta \sqrt{\epsilon} + \sqrt{\delta^{3} \sqrt{\epsilon}}\right)^2}{1- \delta \sqrt{\epsilon}}  .

On the other hand assuming that $\tilde{\sigma}_{m+1}(\tilde{x}^*) = \min_{i \in [m+1]} \tilde{\sigma}_{i}(\tilde{x}^*) =: \epsilon$ and that $\epsilon \leq 1/4$, one has 

\tilde{v}(\tilde{x}^*) - v(x^*) \leq - \frac{1}{2} \log(1 - \epsilon) + \frac{8 \epsilon^2}{(1-\epsilon)^2}.

Before going into the proof let us see briefly how Theorem \ref{th:V1} give the two inequalities stated at the beginning of Section \ref{sec:analysis}. To prove \eqref{eq:analysis2} we use \eqref{eq:thV11} with $\delta=1/5$ and $\epsilon \leq 0.006$, and we observe that in this case the right hand side of \eqref{eq:thV11} is lower bounded by $\frac{1}{20} \sqrt{\epsilon}$. On the other hand to prove \eqref{eq:analysis1} we use \eqref{eq:thV12}, and we observe that for $\epsilon \leq 0.006$ the right hand side of \eqref{eq:thV12} is upper bounded by $\epsilon$.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 2.7 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem27.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem27.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_03_04_constraints_and_the_volumetric_barrier.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Theorem 2.6](./theorem-2-6.md)
- Next: [Lemma 3.1](./lemma-3-1.md)
