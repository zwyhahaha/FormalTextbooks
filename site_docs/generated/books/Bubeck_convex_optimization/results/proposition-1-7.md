# Proposition 1.7

[Bubeck Convex Optimization](../index.md) / [Chapter 1](../chapters/chapter-1.md) / [Section 1.3](../sections/section-1-3-why-convexity.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Lock down the foundational convex-analysis results so later optimization chapters can reuse standard wrappers instead of restating basic geometry.

## Informal Statement

**Proposition** (First order optimality condition)

Let $f$ be convex and $\cX$ a closed convex set on which $f$ is differentiable. Then

\[
x^* \in \argmin_{x \in \cX} f(x) ,
\]

if and only if one has

\[
\nabla f(x^*)^{\top}(x^*-y) \leq 0, \forall y \in \cX .
\]

## Lean Formalization

Symbol: `proposition_1_7_first_order_optimality`

```lean
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
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | First order optimality condition |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | — |
| Lean file | [proofs/Bubeck_convex_optimization/Proposition17.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Proposition17.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/01_03_why_convexity.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/01_03_why_convexity.md) |

## Dependencies

- Reuse Mathlib separation theorems and Optlib subgradient lemmas before introducing bespoke wrappers.

## Chapter Blockers

- Statement alignment between the book's notation and Mathlib or Optlib wrappers still needs cleanup.

## Nearby Results

- Previous: [Proposition 1.6](./proposition-1-6.md)
- Next: [Lemma 2.2](./lemma-2-2.md)
