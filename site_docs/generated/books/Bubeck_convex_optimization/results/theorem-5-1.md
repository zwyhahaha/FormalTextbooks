# Theorem 5.1

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.5.2](../sections/section-5-5-2-saddle-point-mirror-descent-sp-md.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Theorem**

Assume that $\phi(\cdot, y)$ is $L_{\cX}$-Lipschitz w.r.t. $\|\cdot\|_{\cX}$, that is $\|g_{\cX}(x,y)\|_{\cX}^* \leq L_{\cX}, \forall (x, y) \in \cX \times \cY$. Similarly assume that $\phi(x, \cdot)$ is $L_{\cY}$-Lipschitz w.r.t. $\|\cdot\|_{\cY}$. Then SP-MD with $a= \frac{L_{\cX}}{R_{\cX}}$, $b=\frac{L_{\cY}}{R_{\cY}}$, and $\eta=\sqrt{\frac{2}{t}}$ satisfies

\[
\max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t x_s,y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t y_s \right) \leq (R_{\cX} L_{\cX} + R_{\cY} L_{\cY}) \sqrt{\frac{2}{t}}.
\]

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 5.1 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem51.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem51.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_05_02_saddle_point_mirror_descent_sp_md.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_05_02_saddle_point_mirror_descent_sp_md.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Theorem 4.4](./theorem-4-4.md)
- Next: [Theorem 5.2](./theorem-5-2.md)
