# Theorem 3.8

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.3](../sections/section-3-3-conditional-gradient-descent-aka-frank-wolfe.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $f$ be a convex and $\beta$-smooth function w.r.t. some norm $\|\cdot\|$, $R = \sup_{x, y \in \mathcal{X}} \|x - y\|$, and $\gamma_s = \frac{2}{s+1}$ for $s \geq 1$. Then for any $t \geq 2$, one has

\[
f(x_t) - f(x^*) \leq \frac{2 \beta R^2}{t+1} .
\]

## Lean Formalization

Symbol: `theorem_3_8`

```lean
/-- **Theorem 3.8** (Bubeck §3.3): Frank-Wolfe / Conditional Gradient Descent convergence.

0-indexed formulation: x(0) = x₁, x(t+1) is paper's x_{t+2}. The bound
f(x(t+1)) - f(x*) ≤ 2βR²/(t+3) corresponds to paper's f(x_t) - f(x*) ≤ 2βR²/(t+1) for t ≥ 2. -/
theorem theorem_3_8
    {f : E → ℝ} {f' : E → (E →L[ℝ] ℝ)} {β : ℝ}
    (hβ : 0 < β)
    -- β-smoothness upper bound in arbitrary norm
    (hsmooth : ∀ x y : E, f y ≤ f x + f' x (y - x) + β / 2 * ‖y - x‖ ^ 2)
    -- Convexity first-order condition
    (hconv : ∀ x y : E, f x + f' x (y - x) ≤ f y)
    -- Iterates x and linear oracle solutions y (0-indexed)
    {x y : ℕ → E}
    -- x* minimizes f globally
    {xstar : E} (hstar : ∀ z : E, f xstar ≤ f z)
    -- Linear oracle: y(s) minimizes ⟨f'(x(s)), ·⟩ over X, so f'(x(s))(y(s)) ≤ f'(x(s))(x*)
    (horacle : ∀ s : ℕ, f' (x s) (y s) ≤ f' (x s) xstar)
    -- Frank-Wolfe update: x(s+1) = (1-γs)·x(s) + γs·y(s), γs = 2/(s+2) (0-indexed)
    (hupdate : ∀ s : ℕ, x (s + 1) = (1 - 2 / ((s : ℝ) + 2)) • x s + (2 / ((s : ℝ) + 2)) • y s)
    -- Diameter bound
    {R : ℝ} (hR : 0 ≤ R) (hdiam : ∀ s : ℕ, ‖y s - x s‖ ≤ R)
    (t : ℕ) :
    f (x (t + 1)) - f xstar ≤ 2 * β * R ^ 2 / ((t : ℝ) + 3) := by
  -- Set up the suboptimality sequence
  set δ : ℕ → ℝ := fun k => f (x k) - f xstar with hδ_def
  -- Derive the per-step Frank-Wolfe recurrence
  have hrec : ∀ s : ℕ, δ (s + 1) ≤ (1 - 2 / ((s : ℝ) + 2)) * δ s +
      β / 2 * (2 / ((s : ℝ) + 2)) ^ 2 * R ^ 2 := by
    intro s
    set γ := (2 : ℝ) / ((s : ℝ) + 2) with hγ_def
    have hs2_pos : (0 : ℝ) < (s : ℝ) + 2 := by positivity
    have hγ_pos : 0 < γ := by positivity
    -- The update step: x(s+1) - x(s) = γ • (y(s) - x(s))
    have hstep : x (s + 1) - x s = γ • (y s - x s) := by
      rw [hupdate s, smul_sub,
          show (1 - γ) • x s = x s - γ • x s from by rw [sub_smul, one_smul]]
      abel
    -- Norm bound: ‖x(s+1) - x(s)‖² ≤ γ² * R²
    have hnorm_sq : ‖x (s + 1) - x s‖ ^ 2 ≤ γ ^ 2 * R ^ 2 := by
      rw [hstep, norm_smul, Real.norm_eq_abs, abs_of_pos hγ_pos]
      have hd := hdiam s
      have hnn := norm_nonneg (y s - x s)
      have hle : γ * ‖y s - x s‖ ≤ γ * R := mul_le_mul_of_nonneg_left hd hγ_pos.le
      have hRnn : 0 ≤ γ * R := mul_nonneg hγ_pos.le hR
      nlinarith [sq_nonneg (γ * R - γ * ‖y s - x s‖),
                 mul_nonneg hγ_pos.le hnn, sq_nonneg (γ * ‖y s - x s‖)]
    -- Linearity of f': f'(x s)(x(s+1) - x s) = γ * f'(x s)(y s - x s)
    have hlin : f' (x s) (x (s + 1) - x s) = γ * f' (x s) (y s - x s) := by
      rw [hstep, map_smul, smul_eq_mul]
    -- Oracle: f'(x s)(y s - x s) ≤ f'(x s)(x* - x s)
    have horacle_s : f' (x s) (y s - x s) ≤ f' (x s) (xstar - x s) := by
      have h1 : f' (x s) (y s - x s) = f' (x s) (y s) - f' (x s) (x s) := map_sub _ _ _
      have h2 : f' (x s) (xstar - x s) = f' (x s) xstar - f' (x s) (x s) := map_sub _ _ _
      linarith [horacle s]
    -- Convexity: f'(x s)(x* - x s) ≤ f(x*) - f(x s)
    have hconv_s : f' (x s) (xstar - x s) ≤ f xstar - f (x s) :=
      by linarith [hconv (x s) xstar]
    -- Combine into recurrence for δ
    simp only [δ, hδ_def]
    have hsmooth_s := hsmooth (x s) (x (s + 1))
    have hβ2 : (0 : ℝ) ≤ β / 2 := by linarith
    calc f (x (s + 1)) - f xstar
        ≤ f (x s) + f' (x s) (x (s + 1) - x s) + β / 2 * ‖x (s + 1) - x s‖ ^ 2 - f xstar :=
          by linarith
      _ = f (x s) + γ * f' (x s) (y s - x s) + β / 2 * ‖x (s + 1) - x s‖ ^ 2 - f xstar :=
          by rw [hlin]
      _ ≤ f (x s) + γ * (f xstar - f (x s)) + β / 2 * ‖x (s + 1) - x s‖ ^ 2 - f xstar := by
          have := mul_le_mul_of_nonneg_left (le_trans horacle_s hconv_s) hγ_pos.le
          linarith
      _ ≤ f (x s) + γ * (f xstar - f (x s)) + β / 2 * (γ ^ 2 * R ^ 2) - f xstar := by
          have hmul := mul_le_mul_of_nonneg_left hnorm_sq hβ2
          linarith
      _ = (1 - γ) * (f (x s) - f xstar) + β / 2 * γ ^ 2 * R ^ 2 := by ring
      _ = (1 - 2 / ((s : ℝ) + 2)) * δ s + β / 2 * (2 / ((s : ℝ) + 2)) ^ 2 * R ^ 2 := by
          simp only [δ, hγ_def]
  -- Apply the recurrence bound
  have := fw_recurrence_bound δ β R hβ hR hrec t
  simp only [δ] at this
  exact this
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.8 |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | 23m 40s |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem38.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem38.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_03_conditional_gradient_descent_aka_frank_w.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_03_conditional_gradient_descent_aka_frank_w.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Theorem 3.7](./theorem-3-7.md)
- Next: [Theorem 3.9](./theorem-3-9.md)
