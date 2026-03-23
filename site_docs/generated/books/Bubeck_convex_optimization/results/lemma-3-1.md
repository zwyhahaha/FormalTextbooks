# Lemma 3.1

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.0](../sections/section-3-0-dimension-free-convex-optimization.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Lemma**

Let $x \in \cX$ and $y \in \R^n$, then

\[
(\Pi_{\cX}(y) - x)^{\top} (\Pi_{\cX}(y) - y) \leq 0 ,
\]

which also implies $\|\Pi_{\cX}(y) - x\|^2 + \|y - \Pi_{\cX}(y)\|^2 \leq \|y - x\|^2$.

\clip (0.4,-0.4) rectangle (-1.2,1.2);
\draw[rotate=30, very thick] (0,0) ellipse (0.5 and 0.7);
\node [tokens=1] (noeud1) at (-0.45,-0.1) [label=right:{$x$}] {};
\node [tokens=1] (noeud2) at (-0.6, 0.8) [label=above left:{$y$}] {};
\draw[<->, thick] (noeud1) -- (noeud2) node[midway, below left] {$\|y - x \|$};
\node [tokens=1] (noeud3) at (-60:-0.7) [label=below right:{$\Pi_{\cX}(y)$}] {};
\draw[<->, thick] (noeud2) -- (noeud3) node[midway, above right] {$\|y - \Pi_{\cX}(y) \|$};
\draw[<->, thick] (noeud1) -- (noeud3) node[midway, right] {$\|\Pi_{\cX}(y) - x\|$};
\node at (0.15,-0.2) {$\cX$};

\caption{Illustration of Lemma \ref{lem:todonow}.}

Unless specified otherwise all the proofs in this chapter are taken from \cite{Nes04} (with slight simplification in some cases).

## Lean Formalization

Symbol: `lemma_3_1_inner`

```lean
import Mathlib.Analysis.InnerProductSpace.Projection

set_option linter.unusedSectionVars false

open InnerProductSpace

/-!
# Lemma 3.1 — Projection Lemma (Bubeck §3)

Source: papers/Bubeck_convex_optimization/sections/03_00_dimension_free_convex_optimization.md

Let 𝒳 ⊆ ℝⁿ be a compact convex set. Define Π_𝒳(y) = argmin_{z ∈ 𝒳} ‖y - z‖.
For all x ∈ 𝒳 and y ∈ ℝⁿ:
  1. ⟪Π_𝒳(y) - x, Π_𝒳(y) - y⟫_ℝ ≤ 0
  2. ‖Π_𝒳(y) - x‖² + ‖y - Π_𝒳(y)‖² ≤ ‖y - x‖²

We work in a general real inner product space F.
The projection p is characterised abstractly as any point in 𝒳 that minimises ‖y - p‖.
Key Mathlib lemmas: `norm_eq_iInf_iff_real_inner_le_zero`, `inner_neg_neg`, `norm_add_sq_real`.
-/

variable {F : Type*} [NormedAddCommGroup F] [InnerProductSpace ℝ F]

/-- **Lemma 3.1, Part 1** (Bubeck §3): inner-product inequality for the projection.

If p ∈ 𝒳 minimises ‖y - p‖ over the convex set 𝒳, then for every x ∈ 𝒳:
  ⟪p - x, p - y⟫_ℝ ≤ 0. -/
theorem lemma_3_1_inner
    {𝒳 : Set F} (h𝒳 : Convex ℝ 𝒳)
    {x y p : F} (hx : x ∈ 𝒳) (hp : p ∈ 𝒳)
    (hp_min : ‖y - p‖ = ⨅ w : 𝒳, ‖y - w‖) :
    ⟪p - x, p - y⟫_ℝ ≤ 0 := by
  -- norm_eq_iInf_iff_real_inner_le_zero gives: ⟪y - p, x - p⟫_ℝ ≤ 0
  have h := (norm_eq_iInf_iff_real_inner_le_zero h𝒳 hp).mp hp_min x hx
  -- h : ⟪y - p, x - p⟫_ℝ ≤ 0
  -- ⟪p - x, p - y⟫_ℝ = ⟪-(x-p), -(y-p)⟫_ℝ = ⟪x-p, y-p⟫_ℝ = ⟪y-p, x-p⟫_ℝ
  have heq : ⟪p - x, p - y⟫_ℝ = ⟪y - p, x - p⟫_ℝ := by
    rw [← neg_sub x p, ← neg_sub y p, inner_neg_neg, real_inner_comm]
  linarith [heq]

/-- **Lemma 3.1, Part 2** (Bubeck §3): Pythagorean inequality for the projection.

If p ∈ 𝒳 minimises ‖y - p‖ over the convex set 𝒳, then for every x ∈ 𝒳:
  ‖p - x‖² + ‖y - p‖² ≤ ‖y - x‖². -/
theorem lemma_3_1_pythagorean
    {𝒳 : Set F} (h𝒳 : Convex ℝ 𝒳)
    {x y p : F} (hx : x ∈ 𝒳) (hp : p ∈ 𝒳)
    (hp_min : ‖y - p‖ = ⨅ w : 𝒳, ‖y - w‖) :
    ‖p - x‖ ^ 2 + ‖y - p‖ ^ 2 ≤ ‖y - x‖ ^ 2 := by
  have hinner : ⟪p - x, p - y⟫_ℝ ≤ 0 :=
    lemma_3_1_inner h𝒳 hx hp hp_min
  -- Expand: ‖y - x‖² = ‖(y - p) + (p - x)‖² = ‖y-p‖² + 2⟪y-p, p-x⟫_ℝ + ‖p-x‖²
  have hexpand : ‖y - x‖ ^ 2 = ‖y - p‖ ^ 2 + 2 * ⟪y - p, p - x⟫_ℝ + ‖p - x‖ ^ 2 := by
    have : y - x = (y - p) + (p - x) := by abel
    rw [this, norm_add_sq_real]
  -- ⟪y - p, p - x⟫_ℝ = -⟪p - x, p - y⟫_ℝ  (both sides equal -⟪y-p, x-p⟫_ℝ)
  have hcross : ⟪y - p, p - x⟫_ℝ = -⟪p - x, p - y⟫_ℝ := by
    have heq : ⟪p - x, p - y⟫_ℝ = ⟪y - p, x - p⟫_ℝ := by
      rw [← neg_sub x p, ← neg_sub y p, inner_neg_neg, real_inner_comm]
    -- ⟪y - p, p - x⟫_ℝ = -⟪y - p, x - p⟫_ℝ  (p - x = -(x - p))
    have h2 : ⟪y - p, p - x⟫_ℝ = -⟪y - p, x - p⟫_ℝ := by
      rw [← neg_sub x p, inner_neg_right]
    linarith [heq, h2]
  linarith [hexpand, hcross]
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 3.1 |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | 59m 4s |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma31.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma31.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_00_dimension_free_convex_optimization.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_00_dimension_free_convex_optimization.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 2.7](./theorem-2-7.md)
- Next: [Theorem 3.2](./theorem-3-2.md)
