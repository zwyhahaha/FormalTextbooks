import Optlib.Function.Lsmooth
import Mathlib.Analysis.InnerProductSpace.Projection
import Mathlib.Analysis.Convex.Strong
import Optlib.Convex.StronglyConvex
import Mathlib.Analysis.SpecialFunctions.Exp

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open InnerProductSpace Set Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Theorem 3.10 — Projected Gradient Descent for α-strongly convex and β-smooth functions
(Bubeck §3.4.2)

Source: papers/Bubeck_convex_optimization/sections/03_04_02_strongly_convex_and_smooth_functions.md

Let f be α-strongly convex and β-smooth on 𝒳. Then projected gradient descent with η = 1/β
satisfies for all t ≥ 0:
  ‖x_t - x*‖² ≤ exp(-t/κ) * ‖x_0 - x*‖²
where κ = β/α is the condition number. (0-indexed: x_0 = paper's x_1.)

Key proof: using the improved Lemma (eq:improvedstrongsmooth) which combines Lemma 3.6 with
strong convexity to get the extra -α/2‖·‖² term, yielding the linear convergence rate.
-/

/-! ### Helper: inner product with real scalar -/

private lemma real_inner_smul_left' {F : Type*} [NormedAddCommGroup F] [InnerProductSpace ℝ F]
    (r : ℝ) (x y : F) : ⟪r • x, y⟫_ℝ = r * ⟪x, y⟫_ℝ := by
  rw [real_inner_comm, inner_smul_right, real_inner_comm]

/-! ### Improved progress bound (Lemma 3.6 + strong convexity) -/

/-- eq:improvedstrongsmooth: For f α-strongly convex and β-smooth, projected gradient descent
satisfies: f(xp) - f(y) ≤ ⟪β•(x-xp), x-y⟫ - 1/(2β)‖β•(x-xp)‖² - α/2 ‖x-y‖² -/
private lemma improved_progress_bound
    {f : E → ℝ} {f' : E → E} {α β : ℝ}
    (hα : 0 < α) (hβ : 0 < β)
    {X : Set E}
    -- Strong convexity lower bound: α/2 * ‖a-b‖² ≤ f(a) - f(b) - ⟪f'(b), a-b⟫
    (hsc : ∀ a b : E, α / 2 * ‖a - b‖ ^ 2 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    -- β-smoothness upper bound: f(a) - f(b) - ⟪f'(b), a-b⟫ ≤ β/2 * ‖a-b‖²
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    {x xp y : E}
    (hxp_mem : xp ∈ X)
    (hy_mem : y ∈ X)
    -- x⁺ = Π_X(x - (1/β)f'(x))
    (hproj : ∀ z ∈ X, ⟪(x - (1 / β) • f' x) - xp, z - xp⟫_ℝ ≤ 0) :
    f xp - f y ≤ ⟪β • (x - xp), x - y⟫_ℝ - 1 / (2 * β) * ‖β • (x - xp)‖ ^ 2
                - α / 2 * ‖x - y‖ ^ 2 := by
  -- Step 1: Projection inequality at z = y
  have hproj_y := hproj y hy_mem
  have hineq : ⟪x - xp, y - xp⟫_ℝ - 1 / β * ⟪f' x, y - xp⟫_ℝ ≤ 0 := by
    have heq : (x - (1 / β) • f' x) - xp = (x - xp) - (1 / β) • f' x := by abel
    rw [heq, inner_sub_left, real_inner_smul_left'] at hproj_y
    linarith
  -- Step 2: ⟪f'x, xp-y⟫ ≤ ⟪β•(x-xp), xp-y⟫
  have hkey : ⟪f' x, xp - y⟫_ℝ ≤ ⟪β • (x - xp), xp - y⟫_ℝ := by
    have h_mid : β * ⟪x - xp, y - xp⟫_ℝ ≤ ⟪f' x, y - xp⟫_ℝ := by
      have h1 : ⟪x - xp, y - xp⟫_ℝ ≤ 1 / β * ⟪f' x, y - xp⟫_ℝ := by linarith
      calc β * ⟪x - xp, y - xp⟫_ℝ
          ≤ β * (1 / β * ⟪f' x, y - xp⟫_ℝ) := mul_le_mul_of_nonneg_left h1 hβ.le
        _ = ⟪f' x, y - xp⟫_ℝ := by field_simp
    rw [show xp - y = -(y - xp) from by abel, inner_neg_right, inner_neg_right,
        real_inner_smul_left']
    linarith
  -- Step 3: Smoothness: f(xp) - f(x) ≤ ⟪f'x, xp-x⟫ + β/2 ‖xp-x‖²
  have hsmooth : f xp - f x ≤ ⟪f' x, xp - x⟫_ℝ + β / 2 * ‖xp - x‖ ^ 2 := by
    linarith [hup xp x]
  -- Step 4: Strong convexity: f(x) - f(y) ≤ ⟪f'x, x-y⟫ - α/2 ‖x-y‖²
  have hsc_ineq : f x - f y ≤ ⟪f' x, x - y⟫_ℝ - α / 2 * ‖x - y‖ ^ 2 := by
    have h := hsc y x
    have hn : ‖y - x‖ ^ 2 = ‖x - y‖ ^ 2 := norm_sub_rev y x ▸ rfl
    have hi : ⟪f' x, y - x⟫_ℝ = -⟪f' x, x - y⟫_ℝ := by
      rw [show y - x = -(x - y) from by abel, inner_neg_right]
    linarith [hn ▸ hi ▸ h]
  -- Combine: f(xp) - f(y) ≤ ⟪f'x, xp-y⟫ + β/2 ‖xp-x‖² - α/2 ‖x-y‖²
  have hcomb : f xp - f y ≤ ⟪f' x, xp - y⟫_ℝ + β / 2 * ‖xp - x‖ ^ 2
               - α / 2 * ‖x - y‖ ^ 2 := by
    have hsplit : ⟪f' x, xp - y⟫_ℝ = ⟪f' x, xp - x⟫_ℝ + ⟪f' x, x - y⟫_ℝ := by
      rw [← inner_add_right]; congr 1; abel
    linarith
  -- Apply hkey: replace ⟪f'x, xp-y⟫ ≤ ⟪β•(x-xp), xp-y⟫
  have hstep5 : f xp - f y ≤ ⟪β • (x - xp), xp - y⟫_ℝ + β / 2 * ‖xp - x‖ ^ 2
               - α / 2 * ‖x - y‖ ^ 2 := le_trans hcomb (by linarith [hkey])
  -- Expand: ⟪β•(x-xp), xp-y⟫ = ⟪β•(x-xp), x-y⟫ - β‖x-xp‖²
  have hself : ⟪β • (x - xp), x - xp⟫_ℝ = β * ‖x - xp‖ ^ 2 := by
    rw [real_inner_smul_left', real_inner_self_eq_norm_sq]
  have hexpand : ⟪β • (x - xp), xp - y⟫_ℝ = ⟪β • (x - xp), x - y⟫_ℝ - β * ‖x - xp‖ ^ 2 := by
    rw [show xp - y = (x - y) - (x - xp) from by abel, inner_sub_right]; linarith [hself]
  have hnorm_sym : ‖xp - x‖ ^ 2 = ‖x - xp‖ ^ 2 := by rw [norm_sub_rev]
  have hnorm_id : 1 / (2 * β) * ‖β • (x - xp)‖ ^ 2 = β / 2 * ‖x - xp‖ ^ 2 := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos hβ]; field_simp; ring
  rw [hexpand] at hstep5
  rw [hnorm_sym] at hstep5
  linarith [hnorm_id]

/-! ### Per-step norm contraction -/

/-- Per-step bound: ‖xp - x*‖² ≤ (1 - α/β) * ‖x - x*‖² -/
private lemma one_step_norm_sq_bound
    {f : E → ℝ} {f' : E → E} {α β : ℝ}
    (hα : 0 < α) (hβ : 0 < β) (hαβ : α ≤ β)
    {X : Set E}
    (hsc : ∀ a b : E, α / 2 * ‖a - b‖ ^ 2 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    {x xp xstar : E}
    (hxp_mem : xp ∈ X) (hxstar_mem : xstar ∈ X)
    (hstar : ∀ z ∈ X, f xstar ≤ f z)
    (hproj : ∀ z ∈ X, ⟪(x - (1 / β) • f' x) - xp, z - xp⟫_ℝ ≤ 0) :
    ‖xp - xstar‖ ^ 2 ≤ (1 - α / β) * ‖x - xstar‖ ^ 2 := by
  -- Improved progress bound with y = xstar
  have himproved := improved_progress_bound hα hβ hsc hup hxp_mem hxstar_mem hproj
  -- x* minimizes f: 0 ≤ f(xp) - f(x*)
  have hopt : 0 ≤ f xp - f xstar := sub_nonneg.mpr (hstar xp hxp_mem)
  -- Inner product lower bound
  have hinner_lb : 1 / (2 * β) * ‖β • (x - xp)‖ ^ 2 + α / 2 * ‖x - xstar‖ ^ 2 ≤
      ⟪β • (x - xp), x - xstar⟫_ℝ := by linarith
  -- Norm expansion: ‖xp - xstar‖² = ‖x - xstar‖² - (2/β)⟪β•(x-xp), x-xstar⟫ + (1/β²)‖β•(x-xp)‖²
  have hnorm_eq : ‖xp - xstar‖ ^ 2 = ‖x - xstar‖ ^ 2
      - 2 / β * ⟪β • (x - xp), x - xstar⟫_ℝ
      + 1 / β ^ 2 * ‖β • (x - xp)‖ ^ 2 := by
    -- xp - xstar = (x - xstar) - (1/β) • (β • (x - xp))
    have hid : xp - xstar = (x - xstar) - (1 / β) • (β • (x - xp)) := by
      rw [smul_smul, one_div, inv_mul_cancel₀ (ne_of_gt hβ), one_smul]; abel
    rw [hid, norm_sub_sq_real]
    have h1 : ⟪x - xstar, (1 / β) • (β • (x - xp))⟫_ℝ =
        1 / β * ⟪β • (x - xp), x - xstar⟫_ℝ := by
      rw [inner_smul_right, real_inner_comm]
    have h2 : ‖(1 / β) • (β • (x - xp))‖ ^ 2 = 1 / β ^ 2 * ‖β • (x - xp)‖ ^ 2 := by
      rw [norm_smul, Real.norm_eq_abs, abs_of_pos (by positivity)]
      ring
    rw [h1, h2]; ring
  -- Combine to get contraction
  rw [hnorm_eq]
  have hbound : 1 / β ^ 2 * ‖β • (x - xp)‖ ^ 2 - 2 / β * ⟪β • (x - xp), x - xstar⟫_ℝ ≤
      -(α / β) * ‖x - xstar‖ ^ 2 := by
    have h_lb2 : 2 / β * (1 / (2 * β) * ‖β • (x - xp)‖ ^ 2 + α / 2 * ‖x - xstar‖ ^ 2) ≤
        2 / β * ⟪β • (x - xp), x - xstar⟫_ℝ :=
      mul_le_mul_of_nonneg_left hinner_lb (by positivity)
    have h_expand : 2 / β * (1 / (2 * β) * ‖β • (x - xp)‖ ^ 2 + α / 2 * ‖x - xstar‖ ^ 2) =
        1 / β ^ 2 * ‖β • (x - xp)‖ ^ 2 + α / β * ‖x - xstar‖ ^ 2 := by
      field_simp; ring
    linarith
  linarith [show (1 - α / β) * ‖x - xstar‖ ^ 2 =
      ‖x - xstar‖ ^ 2 - α / β * ‖x - xstar‖ ^ 2 from by ring]

/-! ### Main Theorem -/

/-- **Theorem 3.10** (Bubeck §3.4.2): Projected gradient descent with step size η = 1/β
for an α-strongly convex and β-smooth function satisfies:
  ‖x_t - x*‖² ≤ exp(-t/κ) * ‖x_0 - x*‖²
where κ = β/α. (0-indexed: x_0 is the initial point, paper's x_1.) -/
theorem theorem_3_10
    {f : E → ℝ} {f' : E → E} {α β : ℝ}
    (hα : 0 < α) (hβ : 0 < β) (hαβ : α ≤ β)
    {X : Set E}
    -- α-strongly convex first-order condition: α/2 * ‖a-b‖² ≤ f(a) - f(b) - ⟪f'(b), a-b⟫
    (hsc : ∀ a b : E, α / 2 * ‖a - b‖ ^ 2 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    -- β-smooth first-order condition: f(a) - f(b) - ⟪f'(b), a-b⟫ ≤ β/2 * ‖a-b‖²
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    -- x* is the minimizer of f over X
    {xstar : E} (hxstar_mem : xstar ∈ X) (hstar : ∀ z ∈ X, f xstar ≤ f z)
    -- Iterates (0-indexed)
    (x : ℕ → E)
    (hx_mem : ∀ k, x k ∈ X)
    -- x(k+1) = Π_X(x(k) - (1/β)∇f(x(k)))
    (hproj : ∀ k, ∀ z ∈ X, ⟪(x k - (1 / β) • f' (x k)) - x (k + 1), z - x (k + 1)⟫_ℝ ≤ 0)
    (t : ℕ) :
    ‖x t - xstar‖ ^ 2 ≤ Real.exp (-(t : ℝ) / (β / α)) * ‖x 0 - xstar‖ ^ 2 := by
  -- Step 1: Per-step contraction ‖x(k+1) - x*‖² ≤ (1 - α/β) * ‖x(k) - x*‖²
  have hstep : ∀ k, ‖x (k + 1) - xstar‖ ^ 2 ≤ (1 - α / β) * ‖x k - xstar‖ ^ 2 := fun k =>
    one_step_norm_sq_bound hα hβ hαβ hsc hup (hx_mem (k + 1)) hxstar_mem hstar (hproj k)
  -- Step 2: Geometric bound by induction ‖x(t) - x*‖² ≤ (1 - α/β)^t * ‖x(0) - x*‖²
  have h1_nn : 0 ≤ 1 - α / β := by
    have : α / β ≤ 1 := div_le_one_of_le₀ hαβ hβ.le
    linarith
  have hgeom : ∀ k, ‖x k - xstar‖ ^ 2 ≤ (1 - α / β) ^ k * ‖x 0 - xstar‖ ^ 2 := by
    intro k
    induction k with
    | zero => simp
    | succ n ih =>
      calc ‖x (n + 1) - xstar‖ ^ 2
          ≤ (1 - α / β) * ‖x n - xstar‖ ^ 2 := hstep n
        _ ≤ (1 - α / β) * ((1 - α / β) ^ n * ‖x 0 - xstar‖ ^ 2) :=
            mul_le_mul_of_nonneg_left ih h1_nn
        _ = (1 - α / β) ^ (n + 1) * ‖x 0 - xstar‖ ^ 2 := by ring
  -- Step 3: (1 - α/β)^t ≤ exp(-t/κ) using 1 + x ≤ exp(x)
  have hone_sub : 1 - α / β ≤ Real.exp (-(α / β)) := by
    have := Real.add_one_le_exp (-(α / β))
    linarith
  have hpow : (1 - α / β) ^ t ≤ Real.exp (-(α / β)) ^ t :=
    pow_le_pow_left h1_nn hone_sub t
  have hexp_eq : Real.exp (-(α / β)) ^ t = Real.exp (-(t : ℝ) / (β / α)) := by
    rw [← Real.exp_nat_mul]
    congr 1
    field_simp
  calc ‖x t - xstar‖ ^ 2
      ≤ (1 - α / β) ^ t * ‖x 0 - xstar‖ ^ 2 := hgeom t
    _ ≤ Real.exp (-(α / β)) ^ t * ‖x 0 - xstar‖ ^ 2 :=
        mul_le_mul_of_nonneg_right hpow (sq_nonneg _)
    _ = Real.exp (-(t : ℝ) / (β / α)) * ‖x 0 - xstar‖ ^ 2 := by rw [hexp_eq]
