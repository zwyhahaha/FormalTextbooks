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
