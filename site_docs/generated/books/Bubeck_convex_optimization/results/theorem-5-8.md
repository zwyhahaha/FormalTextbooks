# Theorem 5.8

[Bubeck Convex Optimization](../index.md) / [Chapter 5](../chapters/chapter-5.md) / [Section 5.6.4](../sections/section-5-6-4-nu-self-concordant-barriers.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-pending">Pending</span>

**Roadmap context:** <span class="roadmap-pill roadmap-medium">Medium</span> Organize the chapter into reusable subtracks for proximal methods, saddle-point methods, and interior-point methods.

## Informal Statement

**Theorem**

Let $\mathcal{X} \subset \R^n$ be a closed convex set with non-empty interior. There exists $F$ which is a $(c \ n)$-self-concordant barrier for $\mathcal{X}$ (where $c$ is some universal constant).

A key property of $\nu$-self-concordant barriers is the following inequality:

c^{\top} x^*(t) - \min_{x \in \mathcal{X}} c^{\top} x \leq \frac{\nu}{t} ,

see [Equation (4.2.17), \cite{Nes04}]. More generally using \eqref{eq:key} together with \eqref{eq:trucipm3} one obtains

c^{\top} y- \min_{x \in \mathcal{X}} c^{\top} x & \leq & \frac{\nu}{t} + c^{\top} (y - x^*(t)) \notag \\
& = & \frac{\nu}{t} + \frac{1}{t} (\nabla F_t(y) - \nabla F(y))^{\top} (y - x^*(t)) \notag \\ 
& \leq & \frac{\nu}{t} + \frac{1}{t} \|\nabla F_t(y) - \nabla F(y)\|_y^* \cdot \|y - x^*(t)\|_y \notag \\
& \leq & \frac{\nu}{t} + \frac{1}{t} (\lambda_{F_t}(y) + \sqrt{\nu})\frac{\lambda_{F_t} (y)}{1 - \lambda_{F_t}(y)} \label{eq:trucipm4}

In the next section we describe a precise algorithm based on the ideas we developed above. As we will see one cannot ensure to be exactly on the central path, and thus it is useful to generalize the identity \eqref{eq:trucipm11} for a point $x$ close to the central path. We do this as follows:

\lambda_{F_{t'}}(x) & = & \|t' c + \nabla F(x)\|_x^* \notag \\
& = &  \|(t' / t) (t c + \nabla F(x)) + (1- t'/t) \nabla F(x)\|_x^* \notag \\
& \leq & \frac{t'}{t} \lambda_{F_t}(x) + \left(\frac{t'}{t} - 1\right) \sqrt{\nu} .\label{eq:trucipm12}

## Lean Formalization

No Lean snippet is available yet because the proof file does not exist.

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 5.8 |
| Proof file status | `missing` |
| Tracker status | `pending` |
| Computed status | `pending` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem58.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem58.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/05_06_04_nu_self_concordant_barriers.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/05_06_04_nu_self_concordant_barriers.md) |

## Dependencies

- Interior-point results depend on self-concordance definitions and earlier analytic lemmas.

## Chapter Blockers

- The chapter spans several unrelated proof styles, so shared infrastructure is thinner than in earlier chapters.

## Nearby Results

- Previous: [Definition 5.7](./definition-5-7.md)
- Next: [Theorem 5.9](./theorem-5-9.md)
