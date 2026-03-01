import Mathlib
import Optlib.Convex.ConvexFunction

/-!
# Proposition 1.7 — First order optimality condition

Source: papers/Bubeck_convex_optimization/sections/01_03_why_convexity.md

Informal statement:
  Let f be convex and X ⊆ E a closed convex set on which f is differentiable. Then
    x* = argmin_{x ∈ X} f(x)
  if and only if
    ∇f(x*)ᵀ(x* - y) ≤ 0  for all y ∈ X
  (equivalently, ⟪∇f(x*), y - x*⟫_ℝ ≥ 0 for all y ∈ X).

## Proof strategy

(←) Gradient condition → minimiser:
  `Convex_first_order_condition'` gives f(x*) + ⟪∇f(x*), y-x*⟫ ≤ f(y).
  Combined with 0 ≤ ⟪∇f(x*), y-x*⟫, we get f(x*) ≤ f(y).

(→) Minimiser → gradient condition:
  Set g(t) = f(x* + t·(y-x*)).  For t ∈ (0,1], x*+t(y-x*) ∈ X (convexity), so
  g(t) ≥ g(0).  Hence the slope (g(t)-g(0))/t ≥ 0.  By the chain rule, g'(0) = ⟪∇f(x*),y-x*⟫.
  Since the slopes tend to g'(0) and are each ≥ 0, g'(0) ≥ 0.
-/

open Set InnerProductSpace

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-- **Proposition 1.7** (Bubeck §1.3): First order optimality condition for
constrained convex minimisation.

x* minimises f over a closed convex set X if and only if the gradient satisfies
the variational inequality ⟪∇f(x*), y - x*⟫_ℝ ≥ 0 for all y ∈ X. -/
theorem proposition_1_7_first_order_optimality
    {f : E → ℝ} {f' : E → E} {X : Set E} {xstar : E}
    (hf     : ConvexOn ℝ X f)
    (hX     : Convex ℝ X)
    (_hXc   : IsClosed X)
    (hxstar : xstar ∈ X)
    (hgrad  : HasGradientAt f (f' xstar) xstar) :
    IsMinOn f X xstar ↔ ∀ y ∈ X, (0 : ℝ) ≤ ⟪f' xstar, y - xstar⟫_ℝ := by
  constructor
  · -- (→): minimiser → variational inequality ⟪∇f(x*), y-x*⟫ ≥ 0
    intro hmin y hy
    -- For t ∈ [0,1], xstar + t•(y-xstar) = (1-t)•xstar + t•y ∈ X by convexity.
    have hfeas : ∀ t ∈ Icc (0 : ℝ) 1, xstar + t • (y - xstar) ∈ X := by
      intro t ⟨ht0, ht1⟩
      have heq : xstar + t • (y - xstar) = (1 - t) • xstar + t • y := by ring
      rw [heq]
      exact hX hxstar hy (by linarith) ht0 (by linarith)
    -- The path g(t) = f(xstar + t(y-xstar)) has derivative ⟪f'(xstar), y-xstar⟫ at 0.
    have hline : HasDerivAt (fun t : ℝ => xstar + t • (y - xstar)) (y - xstar) 0 := by
      simpa using ((hasDerivAt_id (0 : ℝ)).smul_const (y - xstar)).const_add xstar
    have hgderiv : HasDerivAt (fun t : ℝ => f (xstar + t • (y - xstar)))
                               ⟪f' xstar, y - xstar⟫_ℝ 0 := by
      have hcomp := HasFDerivAt.comp_hasDerivAt 0 hgrad hline
      simp only [Function.comp, innerSL_apply] at hcomp
      exact hcomp
    -- Slopes (g(t)-g(0))/t → ⟪f'(xstar),y-xstar⟫ and each slope ≥ 0 for t ∈ (0,1].
    apply le_of_tendsto
    · -- Tendsto: restrict the full derivative tendsto to the right half-line
      exact (hasDerivAt_iff_tendsto_slope.mp hgderiv).mono_left
              (nhdsWithin_mono 0 (fun _ ht => (Set.mem_Ioi.mp ht).ne'))
    · -- Each slope ≥ 0 on (0,1] ⊂ nhdsWithin 0 (Ioi 0)
      filter_upwards [Ioc_mem_nhdsWithin_Ioi (show (0 : ℝ) < 1 by norm_num)] with t ht
      simp only [slope, sub_zero]
      exact div_nonneg
        (sub_nonneg.mpr (hmin (hfeas t ⟨le_of_lt ht.1, ht.2⟩)))
        (le_of_lt ht.1)
  · -- (←): variational inequality → minimiser
    intro hcond z hz
    -- First-order condition for convexity: f(x*) + ⟪∇f(x*), z-x*⟫ ≤ f(z)
    have hfoc : f xstar + ⟪f' xstar, z - xstar⟫_ℝ ≤ f z :=
      Convex_first_order_condition' hgrad hf hxstar z hz
    -- Combining with 0 ≤ ⟪∇f(x*), z-x*⟫ gives f(x*) ≤ f(z).
    linarith [hcond z hz]
