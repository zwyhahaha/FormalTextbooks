import Optlib.Function.Lsmooth
import Mathlib.Analysis.InnerProductSpace.Projection
import Mathlib.Analysis.Convex.Strong
import Optlib.Convex.StronglyConvex
import Mathlib.Analysis.SpecialFunctions.Exp
import proofs.Bubeck_convex_optimization.Theorem310

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open InnerProductSpace Set Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Theorem 3.12 — Projected Gradient Descent for α-strongly convex and β-smooth functions
(Bubeck §3.4.2)

Source: papers/Bubeck_convex_optimization/sections/03_04_02_strongly_convex_and_smooth_functions.md

Let f be α-strongly convex and β-smooth on 𝒳. Then projected gradient descent with η = 1/β
satisfies for t ≥ 0:
  ‖x_{t+1} - x*‖² ≤ exp(-t/κ) * ‖x_1 - x*‖²
where κ = β/α is the condition number.

This is Theorem 3.10 restated in the paper's 1-indexed notation:
x_1 is the initial point, x_{t+1} is after t gradient steps.
-/

/-- **Theorem 3.12** (Bubeck §3.4.2): Projected gradient descent with step size η = 1/β
for an α-strongly convex and β-smooth function satisfies:
  ‖x_{t+1} - x*‖² ≤ exp(-t/κ) * ‖x_1 - x*‖²
where κ = β/α. Proved by shifting iterates in Theorem 3.10. -/
theorem theorem_3_12
    {f : E → ℝ} {f' : E → E} {α β : ℝ}
    (hα : 0 < α) (hβ : 0 < β) (hαβ : α ≤ β)
    {X : Set E}
    -- α-strongly convex first-order condition
    (hsc : ∀ a b : E, α / 2 * ‖a - b‖ ^ 2 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    -- β-smooth first-order condition
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    -- x* is the minimizer of f over X
    {xstar : E} (hxstar_mem : xstar ∈ X) (hstar : ∀ z ∈ X, f xstar ≤ f z)
    -- Iterates (1-indexed: x 1 is the starting point)
    (x : ℕ → E)
    (hx_mem : ∀ k, x k ∈ X)
    -- x(k+1) = Π_X(x(k) - (1/β)∇f(x(k)))
    (hproj : ∀ k, ∀ z ∈ X, ⟪(x k - (1 / β) • f' (x k)) - x (k + 1), z - x (k + 1)⟫_ℝ ≤ 0)
    (t : ℕ) :
    ‖x (t + 1) - xstar‖ ^ 2 ≤ Real.exp (-(t : ℝ) / (β / α)) * ‖x 1 - xstar‖ ^ 2 := by
  -- Shift iterates: let y k = x (k + 1), so y 0 = x 1 and y t = x (t + 1)
  let y : ℕ → E := fun k => x (k + 1)
  have hy_mem : ∀ k, y k ∈ X := fun k => hx_mem (k + 1)
  have hy_proj : ∀ k, ∀ z ∈ X, ⟪(y k - (1 / β) • f' (y k)) - y (k + 1), z - y (k + 1)⟫_ℝ ≤ 0 :=
    fun k => hproj (k + 1)
  -- Apply Theorem 3.10 to the shifted iterates y
  exact theorem_3_10 hα hβ hαβ hsc hup hxstar_mem hstar y hy_mem hy_proj t
