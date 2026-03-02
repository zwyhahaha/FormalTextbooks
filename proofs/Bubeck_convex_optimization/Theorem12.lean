import Mathlib.Analysis.NormedSpace.HahnBanach.Separation

set_option linter.unusedSectionVars false

/-!
# Theorem 1.2 — Separation Theorem

Source: papers/Bubeck_convex_optimization/sections/01_02_basic_properties_of_convexity.md

Informal statement: Let 𝒳 ⊆ ℝⁿ be a closed convex set, and x₀ ∈ ℝⁿ \ 𝒳. Then there
exist w ∈ ℝⁿ and t ∈ ℝ such that
    wᵀx₀ < t  and  ∀ x ∈ 𝒳, wᵀx ≥ t.

## Relationship to Mathlib

Mathlib's `geometric_hahn_banach_point_closed` gives exactly this, with the "vector w"
playing the role of a separating continuous linear functional f : E →L[ℝ] ℝ.
(In finite dimensions E = ℝⁿ, every such functional is of the form ⟪w, ·⟫ via Riesz.)
-/

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- **Theorem 1.2** (Bubeck §1.2): Separation Theorem.
Let 𝒳 ⊆ E be a closed convex set and x₀ ∉ 𝒳. Then there exists a continuous linear
functional f : E →L[ℝ] ℝ and a threshold t ∈ ℝ such that f(x₀) < t and ∀ x ∈ 𝒳, t ≤ f(x).

In the book's terms (E = ℝⁿ): there exist w ∈ ℝⁿ and t ∈ ℝ such that wᵀx₀ < t
and ∀ x ∈ 𝒳, wᵀx ≥ t. -/
theorem theorem_1_2_separation {𝒳 : Set E} {x₀ : E}
    (hX : Convex ℝ 𝒳) (hXc : IsClosed 𝒳) (hx₀ : x₀ ∉ 𝒳) :
    ∃ (f : E →L[ℝ] ℝ) (t : ℝ), f x₀ < t ∧ ∀ x ∈ 𝒳, t ≤ f x := by
  obtain ⟨f, u, hlt, hge⟩ := geometric_hahn_banach_point_closed hX hXc hx₀
  exact ⟨f, u, hlt, fun x hx => le_of_lt (hge x hx)⟩
