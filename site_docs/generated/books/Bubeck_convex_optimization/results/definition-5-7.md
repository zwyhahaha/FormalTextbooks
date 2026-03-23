# Definition 5.7

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.4](../sections/section-5-6-4-nu-self-concordant-barriers.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Definition**

$F$ is a $\nu$-self-concordant barrier if it is a standard self-concordant function, and it is $\frac1{\nu}$-exp-concave.

Again the canonical example is the logarithmic function, $x \mapsto - \log x$, which is a $1$-self-concordant barrier for the set $\R_{+}$. We state the next theorem without a proof (see \cite{BE14} for more on this result).

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Definition 5.7 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Definition57.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Definition57.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_04_nu_self_concordant_barriers.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_04_nu_self_concordant_barriers.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Theorem 5.6](./theorem-5-6.md)
- Next: [Theorem 5.8](./theorem-5-8.md)
