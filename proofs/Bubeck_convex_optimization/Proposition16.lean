import Optlib.Convex.Subgradient
import Mathlib.Analysis.Convex.Extrema

set_option linter.unusedSectionVars false

/-!
# Proposition 1.6 — Local minima are global minima

Source: papers/Bubeck_convex_optimization/sections/01_03_why_convexity.md

Informal statement:
  Let f : E → ℝ be convex.
  (1) If x is a local minimum of f then x is a global minimum of f.
  (2) Furthermore, x is a global minimum if and only if 0 ∈ ∂f(x).

## Proof strategy

(1) Local → global:
  `IsMinOn.of_isLocalMin_of_convex_univ` (Mathlib) gives exactly this for any
  ordered topological vector space. The key convexity argument is: for any y,
  the convexity inequality f((1-γ)x + γy) ≤ (1-γ)f(x) + γf(y) together with
  local minimality f(x) ≤ f((1-γ)x + γy) for small γ implies f(x) ≤ f(y).

(2) Global min ↔ 0 ∈ ∂f(x):
  `first_order_convex_iff_subgradient` (Optlib): `IsMinOn f univ x ↔ 0 ∈ SubderivAt f x`.
  This follows directly from the definition: `HasSubgradientAt f 0 x` unfolds to
  `∀ y, f x + ⟪0, y - x⟫ ≤ f y`, i.e., `∀ y, f x ≤ f y`.
-/

open Set

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- **Proposition 1.6** (Bubeck §1.3), part 1: local minima of a convex function
are global minima. -/
theorem proposition_1_6_local_is_global
    {f : E → ℝ} {x : E}
    (hf : ConvexOn ℝ univ f)
    (hloc : IsLocalMin f x) :
    IsMinOn f univ x := by
  rw [isMinOn_iff]
  intro y _
  exact IsMinOn.of_isLocalMin_of_convex_univ hloc hf y

/-- **Proposition 1.6** (Bubeck §1.3), part 2: x is a global minimum of f
if and only if 0 ∈ ∂f(x) (i.e., 0 is a subgradient of f at x). -/
theorem proposition_1_6_zero_subdiff_iff
    {f : E → ℝ} {x : E} :
    IsMinOn f univ x ↔ (0 : E) ∈ SubderivAt f x :=
  first_order_convex_iff_subgradient f x
