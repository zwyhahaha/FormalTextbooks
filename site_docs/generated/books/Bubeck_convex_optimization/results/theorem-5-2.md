# Theorem 5.2

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.5.3](../sections/section-5-5-3-saddle-point-mirror-prox-sp-mp.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Theorem**

Assume that $\phi$ is $(\beta_{11}, \beta_{12}, \beta_{22}, \beta_{21})$-smooth. Then SP-MP with $a= \frac{1}{R_{\cX}^2}$, $b=\frac{1}{R_{\cY}^2}$, and 

$\eta= 1 / \left(2 \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right) \right)$
satisfies
\begin{align*}
& \max_{y \in \mathcal{Y}} \phi\left( \frac1{t} \sum_{s=1}^t u_{s+1},y \right) - \min_{x \in \mathcal{X}} \phi\left(x, \frac1{t} \sum_{s=1}^t v_{s+1} \right) \\
& \leq \max \left(\beta_{11} R^2_{\cX}, \beta_{22} R^2_{\cY}, \beta_{12} R_{\cX} R_{\cY}, \beta_{21} R_{\cX} R_{\cY}\right) \frac{4}{t} .
\end{align*}

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 5.2 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem52.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem52.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_05_03_saddle_point_mirror_prox_sp_mp.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_05_03_saddle_point_mirror_prox_sp_mp.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Theorem 5.1](./theorem-5-1.md)
- Next: [Theorem 5.3](./theorem-5-3.md)
