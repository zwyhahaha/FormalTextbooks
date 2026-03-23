# Lemma 3.4

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.2](../sections/section-3-2-gradient-descent-for-smooth-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Lemma**

Let $f$ be a $\beta$-smooth function on $\R^n$. Then for any $x, y \in \R^n$, one has

\[
|f(x) - f(y) - \nabla f(y)^{\top} (x - y)| \leq \frac{\beta}{2} \|x - y\|^2 .
\]

## Lean Formalization

Symbol: `lemma_3_4`

```lean
import Optlib.Function.Lsmooth
import Optlib.Differential.Lemmas
import Mathlib.MeasureTheory.Integral.FundThmCalculus
import Mathlib.Analysis.SpecialFunctions.Integrals

set_option linter.unusedSectionVars false

/-!
# Lemma 3.4 — Sandwich bound for β-smooth functions (Bubeck §3.2)

Source: papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md
Informal statement: Let f be a β-smooth function on ℝⁿ (∇f is β-Lipschitz). Then for any x, y:
  |f(x) - f(y) - ⟨∇f(y), x-y⟩| ≤ β/2 * ‖x-y‖²
Proof: integral representation f(x)-f(y) = ∫₀¹ ⟨∇f(y+t(x-y)), x-y⟩ dt,
  then Cauchy-Schwarz + Lipschitz give the pointwise bound, and ∫₀¹ l·t dt = l/2.
-/

open InnerProductSpace MeasureTheory intervalIntegral Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-- Lemma 3.4 (Bubeck §3.2): For a β-smooth function, the first-order Taylor remainder
    is bounded in absolute value by β/2 * ‖x-y‖². -/
theorem lemma_3_4
    {f : E → ℝ} {f' : E → E}
    (h₁ : ∀ x : E, HasGradientAt f (f' x) x)
    {l : NNReal}
    (h₂ : LipschitzWith l f')
    (x y : E) :
    |f x - f y - ⟪f' y, x - y⟫_ℝ| ≤ (l : ℝ) / 2 * ‖x - y‖ ^ 2 := by
  -- Derivative of g(t) = f(y + t·(x-y)) is ⟨∇f(y+t·(x-y)), x-y⟩
  -- HasGradientAt f (f' z) z = HasFDerivAt f (toDual ℝ E (f' z)) z
  have hderiv : ∀ t : ℝ, HasDerivAt (fun t => f (y + t • (x - y)))
      (⟪f' (y + t • (x - y)), x - y⟫_ℝ) t := by
    intro t
    have hd := deriv_function_comp_segment y x h₁ t
    simp only [InnerProductSpace.toDual_apply] at hd
    exact hd
  -- Continuity of integrand t ↦ ⟨∇f(y+t·(x-y)), x-y⟩
  have hcont : Continuous (fun t : ℝ => ⟪f' (y + t • (x - y)), x - y⟫_ℝ) :=
    Continuous.inner
      (h₂.continuous.comp (continuous_const.add (continuous_id.smul continuous_const)))
      continuous_const
  have hint : IntervalIntegrable (fun t => ⟪f' (y + t • (x - y)), x - y⟫_ℝ) volume 0 1 :=
    hcont.continuousOn.intervalIntegrable_of_Icc (by norm_num)
  -- FTC: ∫₀¹ ⟨∇f(y+t·(x-y)), x-y⟩ dt = f(x) - f(y)
  have hftc : ∫ t in (0 : ℝ)..1, ⟪f' (y + t • (x - y)), x - y⟫_ℝ = f x - f y := by
    have h := integral_eq_sub_of_hasDerivAt
      (f := fun t => f (y + t • (x - y)))
      (f' := fun t => ⟪f' (y + t • (x - y)), x - y⟫_ℝ)
      (fun t _ => hderiv t) hint
    simp only [one_smul, zero_smul, add_zero] at h
    have hxy : y + (x - y) = x := by abel
    rw [hxy] at h; linarith
  -- Rewrite remainder as ∫₀¹ ⟨∇f(y+t·(x-y)) - ∇f(y), x-y⟩ dt
  have heq : f x - f y - ⟪f' y, x - y⟫_ℝ =
      ∫ t in (0 : ℝ)..1, ⟪f' (y + t • (x - y)) - f' y, x - y⟫_ℝ := by
    rw [← hftc,
      show ⟪f' y, x - y⟫_ℝ = ∫ _ in (0 : ℝ)..1, ⟪f' y, x - y⟫_ℝ from by
        simp [intervalIntegral.integral_const],
      ← intervalIntegral.integral_sub hint intervalIntegrable_const]
    congr 1; ext t; rw [inner_sub_left]
  rw [heq]
  -- Pointwise bound: |⟨∇f(y+t·(x-y)) - ∇f(y), x-y⟩| ≤ l · t · ‖x-y‖²
  have hpointwise : ∀ t ∈ Set.Icc (0 : ℝ) 1,
      ‖⟪f' (y + t • (x - y)) - f' y, x - y⟫_ℝ‖ ≤ (l : ℝ) * t * ‖x - y‖ ^ 2 := by
    intro t ht
    calc ‖⟪f' (y + t • (x - y)) - f' y, x - y⟫_ℝ‖
        ≤ ‖f' (y + t • (x - y)) - f' y‖ * ‖x - y‖ := norm_inner_le_norm _ _
      _ ≤ (l : ℝ) * ‖y + t • (x - y) - y‖ * ‖x - y‖ :=
            mul_le_mul_of_nonneg_right
              ((lipschitzWith_iff_norm_sub_le.mp h₂) _ _) (norm_nonneg _)
      _ = (l : ℝ) * t * ‖x - y‖ ^ 2 := by
            simp only [add_sub_cancel_left, norm_smul, Real.norm_eq_abs,
              abs_of_nonneg ht.1]
            ring
  -- Integrabilities for the monotone integral comparison
  have hcont_diff : Continuous (fun t : ℝ => ‖⟪f' (y + t • (x - y)) - f' y, x - y⟫_ℝ‖) :=
    ((h₂.continuous.comp (continuous_const.add (continuous_id.smul continuous_const))).sub
      continuous_const).inner continuous_const |>.norm
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 3.4 |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | 16m 36s |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma34.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma34.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.2](./theorem-3-2.md)
- Next: [Lemma 3.5](./lemma-3-5.md)
