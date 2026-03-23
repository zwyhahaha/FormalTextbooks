# Lemma 3.5

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.2](../sections/section-3-2-gradient-descent-for-smooth-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Lemma**

Let $f$ be such that \eqref{eq:defaltsmooth} holds true. Then for any $x, y \in \R^n$, one has

\[
f(x) - f(y) \leq \nabla f(x)^{\top} (x - y) - \frac{1}{2 \beta} \|\nabla f(x) - \nabla f(y)\|^2 .
\]

## Lean Formalization

Symbol: `lemma_3_5`

```lean
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
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 3.5 |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | 8m 1s |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma35.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma35.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_02_gradient_descent_for_smooth_functions.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Lemma 3.4](./lemma-3-4.md)
- Next: [Theorem 3.3](./theorem-3-3.md)
