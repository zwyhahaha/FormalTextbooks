/-
# Gradient Descent Convergence on L-Smooth Convex Functions

This file formalises the classical O(1/k) convergence rate of gradient descent
on convex, L-smooth (i.e. gradient-Lipschitz) functions.

## The theorem (informal statement)

Let `f : E → ℝ` be convex and L-smooth, meaning its gradient is L-Lipschitz:

    ‖∇f(x) - ∇f(y)‖ ≤ L ‖x - y‖   for all x, y.

Run gradient descent with fixed step size η ∈ (0, 1/L]:

    x_{k+1} = x_k - η ∇f(x_k).

Then for every minimiser x⋆ of f and every k ≥ 1:

    f(x_k) - f(x⋆) ≤ ‖x_0 - x⋆‖² / (2 η k).

## Relationship to optlib

Optlib (`Optlib.Algorithm.GD.GradientDescent`) already provides the full
machine-checked proof of this result as `gradient_method`.  This file:

1. Shows the precise types and hypotheses required by `gradient_method`.
2. Packages everything into a self-contained theorem statement
   (`gradientDescent_convergence`) that a user can apply directly.
3. Includes `sorry`-filled skeleton sub-lemmas illustrating the three-step
   proof structure from the informal proof in `sample-informal-proof.md`:
     - Step 1: descent lemma + one-step decrease.
     - Step 2: Lyapunov / potential inequality.
     - Step 3: telescoping sum → O(1/k) bound.

## Key optlib types

* `HasGradientAt f (f' x) x`         — f is differentiable at x with gradient f'(x)
* `LipschitzWith l f'`               — f' is L-Lipschitz (l : NNReal)
* `ConvexOn ℝ Set.univ f`            — f is convex on all of E
* `Gradient_Descent_fix_stepsize f f' x₀` — the algorithm record bundling
      the iterate sequence, step size, smoothness constant, and update rule.
* `gradient_method`                  — the O(1/k) convergence theorem (fully proved).
-/

import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Topology.Algebra.Order.LiminfLimsup
import Optlib.Algorithm.GD.GradientDescent

/-! ## Notation and universe setup -/

open Set Finset InnerProductSpace

-- We work in a complete inner-product space over ℝ (e.g. ℝⁿ).
variable {E : Type*}
  [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
## Main theorem: O(1/k) convergence of gradient descent

This theorem is a direct wrapper around `gradient_method` from optlib.
It makes explicit every hypothesis that a user must provide and restates
the conclusion in the same notation used in `sample-informal-proof.md`.
-/

/-- **Gradient descent converges at rate O(1/k) on smooth convex functions.**

Given:
- `f : E → ℝ`       convex and L-smooth objective,
- `f' : E → E`      the gradient map,
- `x₀ : E`          the starting point,
- `xm : E`          any minimiser of `f`,
- an instance of `Gradient_Descent_fix_stepsize f f' x₀` recording the
  iterate sequence `x`, step size `a ∈ (0, 1/L]`, and the update rule
  `x (k+1) = x k - a • f' (x k)`,

the following suboptimality bound holds for every `k : ℕ`:

    f (x (k+1)) - f xm ≤ ‖x₀ - xm‖² / (2 (k+1) a).
-/
theorem gradientDescent_convergence
    {f : E → ℝ} {f' : E → E} {x₀ xm : E}
    [alg : Gradient_Descent_fix_stepsize f f' x₀]
    (hfun  : ConvexOn ℝ Set.univ f)
    (step₂ : alg.a ≤ 1 / alg.l)
    (k : ℕ) :
    f (alg.x (k + 1)) - f xm
      ≤ 1 / (2 * (↑k + 1) * alg.a) * ‖x₀ - xm‖ ^ 2 :=
  -- The full proof already lives in optlib; we simply invoke it.
  gradient_method hfun step₂ k

/-!
## Proof skeleton following `sample-informal-proof.md`

The three sub-lemmas below sketch *why* `gradient_method` holds.
They are filled with `sorry` and serve as a guide for a reader who
wants to understand the proof structure before reading the optlib source.
-/

section ProofSkeleton

variable {f : E → ℝ} {f' : E → E} {l : NNReal} {a : ℝ}

/-! ### Step 1 — One-step descent (descent lemma)

If `f` has an L-Lipschitz gradient and `a ≤ 1/L`, then one step of
gradient descent decreases the function value:

    f (x - a • f' x) ≤ f x - (a/2) ‖f'(x)‖².

The key ingredient is `lipschitz_continuos_upper_bound'` from
`Optlib.Function.Lsmooth`, which gives:

    f y ≤ f x + ⟨f'(x), y - x⟩ + (L/2) ‖y - x‖²   for all x, y.
-/
lemma descent_lemma_sketch
    (hdiff  : ∀ x : E, HasGradientAt f (f' x) x)
    (hsmooth : LipschitzWith l f')
    (hl      : (l : ℝ) > 0)
    (ha_pos  : a > 0)
    (ha_step : (l : ℝ) ≤ 1 / a)
    (x : E) :
    f (x - a • f' x) ≤ f x - a / 2 * ‖f' x‖ ^ 2 := by
  -- Apply the quadratic upper bound (descent lemma) at y = x - a • f'(x),
  -- then use a ≤ 1/L to drop the (La/2 - 1)‖∇f‖² term.
  exact convex_lipschitz hdiff hl ha_step ha_pos hsmooth x

/-! ### Step 2 — Lyapunov / potential inequality

Combining convexity (first-order condition) with the one-step descent
gives the key "potential" inequality:

    f (x (k+1)) - f xm
      ≤ 1/(2a) * (‖x k - xm‖² - ‖x (k+1) - xm‖²).

This is `point_descent_for_convex` in optlib.
-/
lemma potential_inequality_sketch
    {x₀ xm : E}
    [alg : Gradient_Descent_fix_stepsize f f' x₀]
    (hfun  : ConvexOn ℝ Set.univ f)
    (step₂ : alg.a ≤ 1 / alg.l)
    (k : ℕ) :
    f (alg.x (k + 1))
      ≤ f xm + 1 / (2 * alg.a) * (‖alg.x k - xm‖ ^ 2 - ‖alg.x (k + 1) - xm‖ ^ 2) :=
  point_descent_for_convex hfun step₂ k

/-! ### Step 3 — Telescoping sum → O(1/k) rate

Sum the potential inequality from k = 0 to k = T-1.
The right-hand side telescopes to `‖x₀ - xm‖² / (2a)`.
Monotone decrease of f(x k) (from Step 1) then gives:

    f (x T) - f xm ≤ ‖x₀ - xm‖² / (2 a T).

This is exactly `gradient_method` in optlib.
-/
lemma telescoping_rate_sketch
    {x₀ xm : E}
    [alg : Gradient_Descent_fix_stepsize f f' x₀]
    (hfun  : ConvexOn ℝ Set.univ f)
    (step₂ : alg.a ≤ 1 / alg.l)
    (k : ℕ) :
    f (alg.x (k + 1)) - f xm
      ≤ 1 / (2 * (↑k + 1) * alg.a) * ‖x₀ - xm‖ ^ 2 := by
  -- Step 3 proof outline:
  -- 1. Obtain per-step bounds from `potential_inequality_sketch`.
  -- 2. Sum over k = 0, …, T-1; the ‖x k - xm‖² terms cancel telescopically.
  -- 3. Drop the ‖x T - xm‖² ≥ 0 term to get the ‖x₀ - xm‖² / (2a) bound.
  -- 4. Use monotone decrease to replace the average by the last iterate value.
  -- The full argument is carried out in `gradient_method`.
  exact gradient_method hfun step₂ k

end ProofSkeleton
