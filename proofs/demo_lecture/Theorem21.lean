import Mathlib.Analysis.InnerProductSpace.Basic
import Optlib.Algorithm.GD.GradientDescent

/-!
# Demo Lecture — Theorem 2.1: Gradient Descent Convergence

Source: papers/demo_lecture/sections/02_gradient_descent.md

Informal statement:
  Let f : ℝⁿ → ℝ be convex and L-smooth (∇f is L-Lipschitz).
  Gradient descent with step size α = 1/L satisfies:
    f(xₖ) - f* ≤ ‖x₀ - x*‖² / (2α k)
  i.e. with α = 1/L:
    f(xₖ) - f* ≤ L · ‖x₀ - x*‖² / (2k)
-/

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-- Theorem 2.1 from the demo lecture: gradient descent convergence rate.

  Given a gradient descent instance with step size exactly α = 1/L,
  and a convex L-smooth objective f, the iterates satisfy the O(1/k) bound. -/
theorem demo_lecture_theorem21
    {f : E → ℝ} {f' : E → E} {x₀ xm : E}
    [alg : Gradient_Descent_fix_stepsize f f' x₀]
    (hfun   : ConvexOn ℝ Set.univ f)
    (hstep  : alg.a = 1 / alg.l)
    (k : ℕ) :
    f (alg.x (k + 1)) - f xm ≤
      1 / (2 * ((k : ℝ) + 1) * alg.a) * ‖x₀ - xm‖ ^ 2 := by
  exact gradient_method hfun (le_of_eq hstep) k
