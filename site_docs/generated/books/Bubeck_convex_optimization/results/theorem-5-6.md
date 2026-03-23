# Theorem 5.6

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.3](../sections/section-5-6-3-self-concordant-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Theorem**

Let $f$ be a standard self-concordant function on $\mathcal{X}$, and $x \in \mathrm{int}(\mathcal{X})$ such that $\lambda_f(x) \leq 1/4$, then

\[
\lambda_f\Big(x - [\nabla^2 f(x)]^{-1} \nabla f(x)\Big) \leq 2 \lambda_f(x)^2 .
\]

In other words the above theorem states that, if initialized at a point $x_0$ such that $\lambda_f(x_0) \leq 1/4$, then Newton's iterates satisfy $\lambda_f(x_{k+1}) \leq 2 \lambda_f(x_k)^2$. Thus, Newton's region of quadratic convergence for self-concordant functions can be described as a ``Newton decrement ball" $\{x : \lambda_f(x) \leq 1/4\}$. In particular by taking the barrier to be a self-concordant function we have now resolved Step (1) of the plan described in Section \ref{sec:barriermethod}.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 5.6 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem56.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem56.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_03_self_concordant_functions.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_03_self_concordant_functions.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Definition 5.5](./definition-5-5.md)
- Next: [Definition 5.7](./definition-5-7.md)
