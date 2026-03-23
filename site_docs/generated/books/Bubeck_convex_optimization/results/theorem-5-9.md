# Theorem 5.9

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.5](../sections/section-5-6-5-path-following-scheme.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Theorem**

The path-following scheme described above satisfies

\[
c^{\top} x_k - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{2 \nu}{t_0} \exp\left( - \frac{k}{1+13\sqrt{\nu}} \right) .
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 5.9 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem59.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem59.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_05_path_following_scheme.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_05_path_following_scheme.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Theorem 5.8](./theorem-5-8.md)
- Next: [Theorem 6.1](./theorem-6-1.md)
