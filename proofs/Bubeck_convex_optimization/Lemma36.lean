import Optlib.Function.Lsmooth
import Mathlib.Analysis.InnerProductSpace.Projection

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open InnerProductSpace Set

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Lemma 3.6 — Progress bound for projected gradient descent (Bubeck §3.2.1)

Source: papers/Bubeck_convex_optimization/sections/03_02_01_the_constrained_case.md

Let x, y ∈ X (convex set), x⁺ = Π_X(x - (1/β)∇f(x)), g_X(x) = β(x - x⁺).
Then: f(x⁺) - f(y) ≤ ⟨g_X(x), x-y⟩ - 1/(2β)‖g_X(x)‖²
-/

/-- Helper: for a real inner product space, ⟪r • x, y⟫_ℝ = r * ⟪x, y⟫_ℝ -/
private lemma real_inner_smul_left' {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (r : ℝ) (x y : E) : ⟪r • x, y⟫_ℝ = r * ⟪x, y⟫_ℝ := by
  rw [real_inner_comm, inner_smul_right, real_inner_comm]

/-- **Lemma 3.6** (Bubeck §3.2.1): Progress bound for projected gradient descent.
Let x, y ∈ X, x⁺ = Π_X(x - (1/β)∇f(x)), g_X(x) = β(x - x⁺). Then
  f(x⁺) - f(y) ≤ ⟨g_X(x), x-y⟩ - 1/(2β) ‖g_X(x)‖² -/
theorem lemma_3_6
    {f : E → ℝ} {f' : E → E} {β : ℝ}
    (hβ : 0 < β)
    {X : Set E} (hX : Convex ℝ X)
    -- Sandwich bound (eq:defaltsmooth): lower bound (convexity) + upper bound (β-smoothness)
    (hlo : ∀ a b : E, 0 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    -- x⁺ = Π_X(x - (1/β)∇f(x)): stated via projection characterization
    {x xp y : E}
    (hxp_mem : xp ∈ X)
    (hy_mem : y ∈ X)
    -- Projection property: ⟨q - x⁺, z - x⁺⟩ ≤ 0 for all z ∈ X, q = x - (1/β)f'(x)
    (hproj : ∀ z ∈ X, ⟪(x - (1 / β) • f' x) - xp, z - xp⟫_ℝ ≤ 0) :
    f xp - f y ≤ ⟪β • (x - xp), x - y⟫_ℝ - 1 / (2 * β) * ‖β • (x - xp)‖ ^ 2 := by
  -- Step 1: Projection inequality at z = y
  -- hproj y: ⟪(x - (1/β)•f'x) - xp, y - xp⟫ ≤ 0
  -- = ⟪(x-xp) - (1/β)•f'x, y-xp⟫ ≤ 0
  -- = ⟪x-xp, y-xp⟫ - (1/β)*⟪f'x, y-xp⟫ ≤ 0
  have hproj_y := hproj y hy_mem
  have hineq : ⟪x - xp, y - xp⟫_ℝ - 1 / β * ⟪f' x, y - xp⟫_ℝ ≤ 0 := by
    have heq : (x - (1 / β) • f' x) - xp = (x - xp) - (1 / β) • f' x := by abel
    rw [heq, inner_sub_left, real_inner_smul_left'] at hproj_y
    linarith
  -- Derive: ⟪f'x, xp-y⟫ ≤ ⟪β•(x-xp), xp-y⟫
  have hkey : ⟪f' x, xp - y⟫_ℝ ≤ ⟪β • (x - xp), xp - y⟫_ℝ := by
    -- Step: β * ⟪x-xp, y-xp⟫ ≤ ⟪f'x, y-xp⟫
    -- From hineq: ⟪x-xp, y-xp⟫ ≤ (1/β) * ⟪f'x, y-xp⟫
    -- Multiply by β > 0
    have h_mid : β * ⟪x - xp, y - xp⟫_ℝ ≤ ⟪f' x, y - xp⟫_ℝ := by
      have h1 : ⟪x - xp, y - xp⟫_ℝ ≤ 1 / β * ⟪f' x, y - xp⟫_ℝ := by linarith
      calc β * ⟪x - xp, y - xp⟫_ℝ
          ≤ β * (1 / β * ⟪f' x, y - xp⟫_ℝ) := mul_le_mul_of_nonneg_left h1 hβ.le
        _ = ⟪f' x, y - xp⟫_ℝ := by field_simp
    -- Rewrite both sides using (xp-y) = -(y-xp)
    rw [show xp - y = -(y - xp) from by abel, inner_neg_right, inner_neg_right,
        real_inner_smul_left']
    -- Goal: -⟪f'x, y-xp⟫ ≤ -(β * ⟪x-xp, y-xp⟫)
    linarith
  -- Step 2: Upper sandwich bound at (xp, x): f(xp) - f(x) ≤ ⟪f'x, xp-x⟫ + β/2 ‖xp-x‖²
  have hsmooth : f xp - f x ≤ ⟪f' x, xp - x⟫_ℝ + β / 2 * ‖xp - x‖ ^ 2 := by
    linarith [hup xp x]
  -- Step 3: Lower sandwich bound at (y, x): 0 ≤ f(y) - f(x) - ⟪f'x, y-x⟫
  --   → f(x) - f(y) ≤ ⟪f'x, x-y⟫
  have hconv : f x - f y ≤ ⟪f' x, x - y⟫_ℝ := by
    have h := hlo y x
    have hflip : ⟪f' x, y - x⟫_ℝ = -⟪f' x, x - y⟫_ℝ := by
      rw [show y - x = -(x - y) from by abel, inner_neg_right]
    linarith
  -- Combine Steps 2 and 3: f(xp) - f(y) ≤ ⟪f'x, xp-y⟫ + β/2 ‖xp-x‖²
  have hcomb : f xp - f y ≤ ⟪f' x, xp - y⟫_ℝ + β / 2 * ‖xp - x‖ ^ 2 := by
    have hsplit : ⟪f' x, xp - y⟫_ℝ = ⟪f' x, xp - x⟫_ℝ + ⟪f' x, x - y⟫_ℝ := by
      rw [← inner_add_right]; congr 1; abel
    linarith
  -- Apply hkey: f(xp)-f(y) ≤ ⟪β•(x-xp), xp-y⟫ + β/2 ‖xp-x‖²
  have hstep5 : f xp - f y ≤ ⟪β • (x - xp), xp - y⟫_ℝ + β / 2 * ‖xp - x‖ ^ 2 :=
    le_trans hcomb (by linarith [hkey])
  -- Expand: ⟪β•(x-xp), xp-y⟫ = ⟪β•(x-xp), x-y⟫ - β‖x-xp‖²
  have hself : ⟪β • (x - xp), x - xp⟫_ℝ = β * ‖x - xp‖ ^ 2 := by
    rw [real_inner_smul_left', real_inner_self_eq_norm_sq]
  have hexpand : ⟪β • (x - xp), xp - y⟫_ℝ = ⟪β • (x - xp), x - y⟫_ℝ - β * ‖x - xp‖ ^ 2 := by
    rw [show xp - y = (x - y) - (x - xp) from by abel, inner_sub_right]
    linarith [hself]
  -- Norm identities
  have hnorm_sym : ‖xp - x‖ ^ 2 = ‖x - xp‖ ^ 2 := by rw [norm_sub_rev]
  have hnorm_id : 1 / (2 * β) * ‖β • (x - xp)‖ ^ 2 = β / 2 * ‖x - xp‖ ^ 2 := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos hβ]
    field_simp; ring
  -- Final combination
  rw [hexpand] at hstep5
  rw [hnorm_sym] at hstep5
  -- hstep5 : f xp - f y ≤ ⟪β•(x-xp), x-y⟫ - β * ‖x-xp‖² + β/2 * ‖x-xp‖²
  linarith [hnorm_id]
