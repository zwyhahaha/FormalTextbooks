import Optlib.Algorithm.GD.GradientDescent

set_option linter.unusedSectionVars false

open InnerProductSpace Set

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Theorem 3.3 — Gradient Descent for β-smooth Convex Functions (Bubeck §3.2)

Source: papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md

Let f be convex and β-smooth on ℝⁿ (i.e., ∇f is β-Lipschitz).
Then gradient descent with η = 1/β satisfies
  f(x_{k+1}) - f(x*) ≤ 2β ‖x₀ - x*‖² / (k+1)

Proof: Wrap optlib's `gradient_method` (stronger bound: β/(2*(k+1)) vs Bubeck's 2β/(k+1)).
-/

/-- **Theorem 3.3** (Bubeck §3.2): Gradient descent with step size η = 1/β for a convex
    β-smooth function f satisfies f(x_{k+1}) - f(x*) ≤ 2β‖x₀-x*‖² / (k+1). -/
theorem theorem_3_3
    {f : E → ℝ} {f' : E → E}
    {β : ℝ} (hβ : 0 < β)
    (hconv : ConvexOn ℝ Set.univ f)
    (hdiff : ∀ x : E, HasGradientAt f (f' x) x)
    (hsmooth : LipschitzWith ⟨β, le_of_lt hβ⟩ f')
    {x₀ xstar : E}
    {x : ℕ → E} (hinit : x 0 = x₀)
    (hupdate : ∀ k, x (k + 1) = x k - (1 / β) • f' (x k))
    (k : ℕ) :
    f (x (k + 1)) - f xstar ≤ 2 * β * ‖x₀ - xstar‖ ^ 2 / (k + 1) := by
  -- Build a Gradient_Descent_fix_stepsize instance with a = 1/β, l = β
  letI myAlg : Gradient_Descent_fix_stepsize f f' x₀ :=
    { x      := x
      a      := 1 / β
      l      := ⟨β, le_of_lt hβ⟩
      diff   := hdiff
      smooth := hsmooth
      update := hupdate
      hl     := by simp only [NNReal.coe_mk]; exact hβ
      step₁  := by positivity
      initial := hinit }
  -- step₂: alg.a ≤ 1 / alg.l  ↔  1/β ≤ 1/β (equality, proved by le_refl)
  have hstep₂ : myAlg.a ≤ 1 / (myAlg.l : ℝ) := by exact le_refl _
  -- Apply optlib gradient_method with xm = xstar
  -- Result: f(x(k+1)) - f(xstar) ≤ 1/(2*(k+1)*(1/β)) * ‖x₀-xstar‖² = β/(2*(k+1)) * ‖x₀-xstar‖²
  have hgm : f (x (k + 1)) - f xstar
      ≤ 1 / (2 * ((k : ℝ) + 1) * (1 / β)) * ‖x₀ - xstar‖ ^ 2 :=
    gradient_method (xm := xstar) hconv hstep₂ k
  -- Weaken: β/(2*(k+1)) ≤ 2β/(k+1)  since  1 ≤ 4
  have hk1 : (0 : ℝ) < (k : ℝ) + 1 := by positivity
  have hweaken : 1 / (2 * ((k : ℝ) + 1) * (1 / β)) * ‖x₀ - xstar‖ ^ 2
      ≤ 2 * β * ‖x₀ - xstar‖ ^ 2 / ((k : ℝ) + 1) := by
    have hR : (0 : ℝ) ≤ ‖x₀ - xstar‖ ^ 2 := sq_nonneg _
    rw [show 1 / (2 * ((k : ℝ) + 1) * (1 / β)) = β / (2 * ((k : ℝ) + 1)) from by field_simp,
        div_mul_eq_mul_div, div_le_div_iff (by positivity) hk1]
    nlinarith [mul_nonneg (mul_nonneg hβ.le hR) hk1.le]
  linarith
