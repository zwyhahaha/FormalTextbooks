# Theorem 5.3

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.2](../sections/section-5-6-2-traditional-analysis-of-newton-s-method.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Theorem**

Assume that $f$ has a Lipschitz Hessian, that is $\| \nabla^2 f(x) - \nabla^2 f(y) \| \leq M \|x - y\|$. Let $x^*$ be local minimum of $f$ with strictly positive Hessian, that is $\nabla^2 f(x^*) \succeq \mu \mI_n$, $\mu > 0$. Suppose that the initial starting point $x_0$ of Newton's method is such that

\[
\|x_0 - x^*\| \leq \frac{\mu}{2 M} .
\]

Then Newton's method is well-defined and converges to $x^*$ at a quadratic rate:

\[
\|x_{k+1} - x^*\| \leq \frac{M}{\mu} \|x_k - x^*\|^2.
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 5.3 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem53.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem53.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_02_traditional_analysis_of_newton_s_method.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_02_traditional_analysis_of_newton_s_method.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Theorem 5.2](./theorem-5-2.md)
- Next: [Definition 5.4](./definition-5-4.md)
