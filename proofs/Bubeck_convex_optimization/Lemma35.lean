import Optlib.Function.Lsmooth

set_option linter.unusedSectionVars false

open InnerProductSpace

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Lemma 3.5 — Improved gradient inequality under β-smoothness (Bubeck §3.2)

Source: papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md
Informal statement:
  Let f be such that for all a, b:
    0 ≤ f(a) - f(b) - ⟨∇f(b), a-b⟩ ≤ β/2 * ‖a-b‖²    (eq:defaltsmooth)
  Then for any x, y:
    f(x) - f(y) ≤ ⟨∇f(x), x-y⟩ - 1/(2β) * ‖∇f(x) - ∇f(y)‖²

Proof: Set z = y - (1/β)(∇f(y) - ∇f(x)). Then:
  f(x) - f(y) = (f(x) - f(z)) + (f(z) - f(y))
  ≤ ⟨∇f(x), x-z⟩ + ⟨∇f(y), z-y⟩ + β/2 * ‖z-y‖²
    [lower bound at (z,x); upper bound at (z,y)]
  = ⟨∇f(x), x-y⟩ - 1/(2β) * ‖∇f(x) - ∇f(y)‖²
    [algebra: z-y = (1/β)(∇f(x)-∇f(y)), so ‖z-y‖² = (1/β)²‖...‖²]
-/

/-- Lemma 3.5 (Bubeck §3.2): Under the sandwich bound (eq:defaltsmooth), one has
    f(x) - f(y) ≤ ⟨∇f(x), x-y⟩ - 1/(2β) * ‖∇f(x) - ∇f(y)‖² -/
theorem lemma_3_5
    {f : E → ℝ} {f' : E → E} {β : ℝ}
    (hβ : 0 < β)
    -- eq:defaltsmooth: lower bound (convexity) and upper bound (β-smoothness)
    (hlo : ∀ a b : E, 0 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    (x y : E) :
    f x - f y ≤ ⟪f' x, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2 := by
  -- Introduce auxiliary point z = y - (1/β)(∇f(y) - ∇f(x))
  set z := y - (1 / β) • (f' y - f' x) with hz_def
  -- Key identities for z
  have hzy : z - y = (1 / β) • (f' x - f' y) := by
    simp only [hz_def, smul_sub]; abel
  have hxz : x - z = (x - y) - (1 / β) • (f' x - f' y) := by
    simp only [hz_def, smul_sub]; abel
  -- Step 1: lower bound at (z, x): 0 ≤ f(z) - f(x) - ⟨∇f(x), z-x⟩
  --   → f(x) - f(z) ≤ ⟨∇f(x), x-z⟩
  have hfxz : f x - f z ≤ ⟪f' x, x - z⟫_ℝ := by
    have h := hlo z x
    have : ⟪f' x, z - x⟫_ℝ = -⟪f' x, x - z⟫_ℝ := by
      rw [show z - x = -(x - z) from by abel, inner_neg_right]
    linarith
  -- Step 2: upper bound at (z, y): f(z) - f(y) - ⟨∇f(y), z-y⟩ ≤ β/2 * ‖z-y‖²
  --   → f(z) - f(y) ≤ ⟨∇f(y), z-y⟩ + β/2 * ‖z-y‖²
  have hfzy : f z - f y ≤ ⟪f' y, z - y⟫_ℝ + β / 2 * ‖z - y‖ ^ 2 := by
    have h := hup z y
    linarith
  -- Expand inner products using the identities for z
  have hinner1 : ⟪f' x, x - z⟫_ℝ = ⟪f' x, x - y⟫_ℝ - 1 / β * ⟪f' x, f' x - f' y⟫_ℝ := by
    rw [hxz, inner_sub_right, inner_smul_right]
  have hinner2 : ⟪f' y, z - y⟫_ℝ = 1 / β * ⟪f' y, f' x - f' y⟫_ℝ := by
    rw [hzy, inner_smul_right]
  -- Norm term: β/2 * ‖z-y‖² = 1/(2β) * ‖∇f(x) - ∇f(y)‖²
  have hnorm : β / 2 * ‖z - y‖ ^ 2 = 1 / (2 * β) * ‖f' x - f' y‖ ^ 2 := by
    rw [hzy, norm_smul, Real.norm_eq_abs, abs_of_pos (div_pos one_pos hβ)]
    field_simp
    ring
  -- Key inner product identity: ⟨∇f(x), ∇f(x)-∇f(y)⟩ - ⟨∇f(y), ∇f(x)-∇f(y)⟩ = ‖∇f(x)-∇f(y)‖²
  have hsub : ⟪f' x, f' x - f' y⟫_ℝ - ⟪f' y, f' x - f' y⟫_ℝ = ‖f' x - f' y‖ ^ 2 := by
    rw [← inner_sub_left, real_inner_self_eq_norm_sq]
  -- Combine: the sum of the two bounds equals ⟨∇f(x), x-y⟩ - 1/(2β) * ‖∇f(x)-∇f(y)‖²
  have hkey : ⟪f' x, x - z⟫_ℝ + (⟪f' y, z - y⟫_ℝ + β / 2 * ‖z - y‖ ^ 2)
      = ⟪f' x, x - y⟫_ℝ - 1 / (2 * β) * ‖f' x - f' y‖ ^ 2 := by
    rw [hinner1, hinner2, hnorm]
    linear_combination (-1 / β) * hsub
  linarith
