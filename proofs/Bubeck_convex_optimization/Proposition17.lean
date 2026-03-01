import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Analysis.Calculus.FDeriv.Comp
import Mathlib.Analysis.InnerProductSpace.Dual
import Mathlib.Topology.Algebra.Order.LiminfLimsup
import Mathlib.Order.Filter.Basic
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

set_option linter.unusedSectionVars false

open Set InnerProductSpace Topology

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
    -- Extract pointwise minimality from filter-based IsMinOn
    have hfmin : ∀ z ∈ X, f xstar ≤ f z := by
      rw [isMinOn_iff] at hmin; exact hmin
    -- Path γ(t) = xstar + t • (y - xstar) stays in X for t ∈ [0,1]
    have hfeas : ∀ t ∈ Icc (0:ℝ) 1, xstar + t • (y - xstar) ∈ X := by
      intro t ⟨ht0, ht1⟩
      have heq : xstar + t • (y - xstar) = (1 - t) • xstar + t • y := by
        simp only [smul_sub, sub_smul, one_smul]; abel
      rw [heq]
      exact hX hxstar hy (by linarith) ht0 (by linarith)
    -- HasDerivAt for the line path γ at t = 0
    have hline : HasDerivAt (fun t : ℝ => xstar + t • (y - xstar)) (y - xstar) 0 := by
      have h1 := (hasDerivAt_id (0 : ℝ)).smul_const (y - xstar)
      simp only [one_smul] at h1
      exact h1.const_add xstar
    -- Chain rule: HasDerivAt (f ∘ γ) ⟪f'(x*), y-x*⟫ 0
    have hgderiv : HasDerivAt (fun t : ℝ => f (xstar + t • (y - xstar)))
                               ⟪f' xstar, y - xstar⟫_ℝ 0 := by
      have hfderiv : HasFDerivAt f ((toDual ℝ E) (f' xstar)) xstar :=
        hasGradientAt_iff_hasFDerivAt.mp hgrad
      have hfderiv' : HasFDerivAt f ((toDual ℝ E) (f' xstar)) (xstar + (0:ℝ) • (y - xstar)) := by
        simp only [zero_smul, add_zero]; exact hfderiv
      have hcomp := hfderiv'.comp_hasDerivAt (0 : ℝ) hline
      simp only [Function.comp, zero_smul, add_zero, toDual_apply] at hcomp
      exact hcomp
    -- The derivative is the limit of slopes from 𝓝[≠] 0
    -- We show the limit is ≥ 0 because slopes from the right are ≥ 0
    have htendsto : Filter.Tendsto (slope (fun t => f (xstar + t • (y - xstar))) 0)
        (𝓝[≠] (0 : ℝ)) (𝓝 ⟪f' xstar, y - xstar⟫_ℝ) :=
      hasDerivAt_iff_tendsto_slope.mp hgderiv
    -- Restrict to 𝓝[Ioi 0] 0 (right-sided limit)
    have htendsto_right : Filter.Tendsto (slope (fun t => f (xstar + t • (y - xstar))) 0)
        (𝓝[Set.Ioi (0 : ℝ)] 0) (𝓝 ⟪f' xstar, y - xstar⟫_ℝ) :=
      htendsto.mono_left (nhdsWithin_mono 0 (fun x (hx : (0 : ℝ) < x) => hx.ne'))
    -- Slopes from the right are ≥ 0 (eventually, for t ∈ (0, 1))
    have hslope_nonneg : ∀ᶠ t in 𝓝[Set.Ioi (0 : ℝ)] 0,
        (0 : ℝ) ≤ slope (fun t => f (xstar + t • (y - xstar))) 0 t := by
      apply Filter.Eventually.mono
        (Ioo_mem_nhdsWithin_Ioi (left_mem_Ico.mpr one_pos))
      intro t ⟨ht_pos, ht_lt_one⟩
      simp only [slope, sub_zero, vsub_eq_sub, zero_smul, add_zero]
      exact smul_nonneg (inv_nonneg.mpr (le_of_lt ht_pos))
        (sub_nonneg.mpr (hfmin _ (hfeas t ⟨le_of_lt ht_pos, le_of_lt ht_lt_one⟩)))
    exact ge_of_tendsto htendsto_right hslope_nonneg
  · -- (←): variational inequality → minimiser
    --
    -- Key fixes vs original attempt:
    --   1. `IsMinOn` is filter-based; unfold with `rw [isMinOn_iff]` before intro-ing z hz.
    --   2. `Convex_first_order_condition'` returns `∀ y ∈ X, ...`; apply fully as `(...) z hz`.
    --   3. Expose the inner product bound as a named `have` so linarith sees both
    --      atoms syntactically before combining.
    intro hcond
    rw [isMinOn_iff]
    intro z hz
    -- First-order condition for convexity: f(x*) + ⟪∇f(x*), z-x*⟫ ≤ f(z)
    have hfoc : f xstar + ⟪f' xstar, z - xstar⟫_ℝ ≤ f z :=
      (Convex_first_order_condition' hgrad hf hxstar) z hz
    -- Variational inequality at z gives: 0 ≤ ⟪∇f(x*), z-x*⟫
    have hinner : (0 : ℝ) ≤ ⟪f' xstar, z - xstar⟫_ℝ := hcond z hz
    -- Combining: f(x*) ≤ f(x*) + ⟪∇f(x*), z-x*⟫ ≤ f(z)
    linarith
