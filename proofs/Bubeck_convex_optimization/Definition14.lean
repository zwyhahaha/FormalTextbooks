import Optlib.Convex.Subgradient

set_option linter.unusedSectionVars false

/-!
# Definition 1.4 — Subgradients

Source: papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md

The book defines: given 𝒳 ⊆ ℝⁿ and f : 𝒳 → ℝ, a vector g ∈ ℝⁿ is a **subgradient**
of f at x ∈ 𝒳 if for every y ∈ 𝒳,

  f(x) − f(y) ≤ gᵀ(x − y)

Equivalently, f lies above the affine minorant y ↦ f(x) + gᵀ(y − x).

The set of all subgradients of f at x is denoted ∂f(x).

## Relationship to Optlib

Optlib's `HasSubgradientWithinAt f g s x` states exactly:
  ∀ y ∈ s, f y ≥ f x + ⟪g, y − x⟫

This is equivalent to the book's condition (negating both sides and noting
⟪g, x−y⟫ = −⟪g, y−x⟫).  The set `SubderivWithinAt f 𝒳 x` is ∂f(x).
-/

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

local notation "⟪" x ", " y "⟫" => @inner ℝ _ _ x y

/-- **Definition 1.4** (Bubeck §1.2): g is a subgradient of f at x within 𝒳
(i.e. g ∈ ∂f(x)) iff for all y ∈ 𝒳, f(x) − f(y) ≤ ⟪g, x−y⟫.

This is equivalent to Optlib's `HasSubgradientWithinAt f g 𝒳 x`. -/
theorem definition_1_4_subgradient {f : E → ℝ} {g x : E} {𝒳 : Set E} :
    HasSubgradientWithinAt f g 𝒳 x ↔
    ∀ y ∈ 𝒳, f x - f y ≤ ⟪g, x - y⟫ := by
  unfold HasSubgradientWithinAt
  constructor
  · intro h y hy
    have hge := h y hy
    have hinner : ⟪g, x - y⟫ = -⟪g, y - x⟫ := by
      rw [← neg_sub, inner_neg_right]
    linarith
  · intro h y hy
    have hle := h y hy
    have hinner : ⟪g, x - y⟫ = -⟪g, y - x⟫ := by
      rw [← neg_sub, inner_neg_right]
    linarith

/-- The subdifferential ∂f(x) within 𝒳 is `SubderivWithinAt f 𝒳 x`. -/
theorem definition_1_4_subdifferential {f : E → ℝ} {x : E} {𝒳 : Set E} :
    SubderivWithinAt f 𝒳 x =
    {g : E | ∀ y ∈ 𝒳, f x - f y ≤ ⟪g, x - y⟫} := by
  ext g
  simp only [SubderivWithinAt, Set.mem_setOf_eq]
  exact definition_1_4_subgradient
