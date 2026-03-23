# Definition 5.4

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.3](../sections/section-5-6-3-self-concordant-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Definition**

Let $\mathcal{X}$ be a convex set with non-empty interior, and $f$ a $C^3$ convex function defined on $\inte(\mathcal{X})$. Then $f$ is self-concordant (with constant $M$) if for all $x \in \inte(\mathcal{X}), h \in \R^n$,

\[
\nabla^3 f(x) [h,h,h] \leq M \|h\|_x^3 .
\]

We say that $f$ is standard self-concordant if $f$ is self-concordant with constant $M=2$.

An easy consequence of the definition is that a self-concordant function is a barrier for the set $\mathcal{X}$, see [Theorem 4.1.4, \cite{Nes04}]. The main example to keep in mind of a standard self-concordant function is $f(x) = - \log x$ for $x > 0$. The next definition will be key in order to describe the region of quadratic convergence for Newton's method on self-concordant functions.

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Definition 5.4 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Definition54.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition54.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_03_self_concordant_functions.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_03_self_concordant_functions.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Theorem 5.3](./theorem-5-3.md)
- Next: [Definition 5.5](./definition-5-5.md)
