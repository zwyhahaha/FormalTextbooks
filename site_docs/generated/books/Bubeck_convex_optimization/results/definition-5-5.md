# Definition 5.5

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.3](../sections/section-5-6-3-self-concordant-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Definition**

Let $f$ be a standard self-concordant function on $\mathcal{X}$. For $x \in \mathrm{int}(\mathcal{X})$, we say that $\lambda_f(x) = \|\nabla f(x)\|_x^*$ is the {\em Newton decrement} of $f$ at $x$.

An important inequality is that for $x$ such that $\lambda_f(x) < 1$, and $x^* = \argmin f(x)$, one has

\|x - x^*\|_x \leq \frac{\lambda_f(x)}{1 - \lambda_f(x)} ,

see [Equation 4.1.18, \cite{Nes04}]. We state the next theorem without a proof, see also [Theorem 4.1.14, \cite{Nes04}].

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Definition 5.5 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Definition55.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition55.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_03_self_concordant_functions.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_03_self_concordant_functions.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Definition 5.4](./definition-5-4.md)
- Next: [Theorem 5.6](./theorem-5-6.md)
