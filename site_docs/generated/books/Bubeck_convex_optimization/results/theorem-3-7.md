# Theorem 3.7

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.2.1](../sections/section-3-2-1-the-constrained-case.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

Let $f$ be convex and $\beta$-smooth on $\cX$. Then projected gradient descent with $\eta = \frac{1}{\beta}$ satisfies

\[
f(x_t) - f(x^*) \leq \frac{3 \beta \|x_1 - x^*\|^2 + f(x_1) - f(x^*)}{t} .
\]

## Lean Formalization

Symbol: `theorem_3_7`

```lean
/-- **Theorem 3.7** (Bubeck §3.2.1): Projected gradient descent convergence.
    f(x(t)) - f(x*) ≤ (3β‖x(0)-x*‖² + (f(x(0))-f(x*))) / (t+1). -/
theorem theorem_3_7
    {f : E → ℝ} {f' : E → E} {β : ℝ}
    (hβ : 0 < β)
    {X : Set E} (hX : Convex ℝ X)
    (hlo : ∀ a b : E, 0 ≤ f a - f b - ⟪f' b, a - b⟫_ℝ)
    (hup : ∀ a b : E, f a - f b - ⟪f' b, a - b⟫_ℝ ≤ β / 2 * ‖a - b‖ ^ 2)
    {x : ℕ → E} (hx_mem : ∀ k, x k ∈ X)
    (hproj : ∀ k, ∀ z ∈ X, ⟪(x k - (1 / β) • f' (x k)) - x (k + 1), z - x (k + 1)⟫_ℝ ≤ 0)
    {xstar : E} (hstar_mem : xstar ∈ X)
    (hstar_min : ∀ y ∈ X, f xstar ≤ f y)
    (t : ℕ) :
    f (x t) - f xstar ≤
      (3 * β * ‖x 0 - xstar‖ ^ 2 + (f (x 0) - f xstar)) / (↑t + 1) := by
  set R := ‖x 0 - xstar‖ with hR_def
  set δ : ℕ → ℝ := fun k => f (x k) - f xstar with hδ_def
  have hδ_nn : ∀ k, 0 ≤ δ k :=
    fun k => by simp only [δ]; linarith [hstar_min (x k) (hx_mem k)]
  -- Lemma 3.6 applied at each step
  have hlem36 : ∀ k, ∀ y ∈ X,
      f (x (k + 1)) - f y ≤
        ⟪β • (x k - x (k + 1)), x k - y⟫_ℝ -
        1 / (2 * β) * ‖β • (x k - x (k + 1))‖ ^ 2 :=
    fun k y hy => lemma_3_6 hβ hX hlo hup (hx_mem (k + 1)) hy (hproj k)
  -- Descent: δ(k+1) ≤ δ(k) - 1/(2β)‖g_k‖²
  have hfunc_desc : ∀ k, δ (k + 1) ≤ δ k - 1 / (2 * β) * ‖β • (x k - x (k + 1))‖ ^ 2 := by
    intro k
    have h := hlem36 k (x k) (hx_mem k)
    have hzero : ⟪β • (x k - x (k + 1)), x k - x k⟫_ℝ = 0 := by simp
    simp only [δ]; linarith
  -- Suboptimality: δ(k+1) ≤ ‖g_k‖·‖x(k)-xstar‖
  have hsubopt : ∀ k, δ (k + 1) ≤ ‖β • (x k - x (k + 1))‖ * ‖x k - xstar‖ := by
    intro k
    have h := hlem36 k xstar hstar_mem
    have hcs := real_inner_le_norm (β • (x k - x (k + 1))) (x k - xstar)
    have hα : 0 ≤ 1 / (2 * β) * ‖β • (x k - x (k + 1))‖ ^ 2 := by positivity
    simp only [δ]; linarith
  -- Distance non-increase: ‖x(k+1)-xstar‖² ≤ ‖x(k)-xstar‖²
  have hdist_mono : ∀ k, ‖x (k + 1) - xstar‖ ^ 2 ≤ ‖x k - xstar‖ ^ 2 := by
    intro k
    -- ⟨β•(x(k)-x(k+1)), x(k)-xstar⟩ ≥ 1/(2β)‖β•(x(k)-x(k+1))‖²
    have h36 := hlem36 k xstar hstar_mem
    have hinner_lb : 1 / (2 * β) * ‖β • (x k - x (k + 1))‖ ^ 2 ≤
        ⟪β • (x k - x (k + 1)), x k - xstar⟫_ℝ := by
      have hδnn : 0 ≤ f (x (k + 1)) - f xstar := hδ_nn (k + 1)
      linarith [h36]
    -- x(k+1) = x(k) - (1/β)·β·(x(k)-x(k+1)) = x(k) - (x(k)-x(k+1)) = x(k+1)
    set g := β • (x k - x (k + 1)) with hg_def
    have hxstep : x (k + 1) = x k - (1 / β) • g := by
      rw [hg_def, smul_smul]
      have h1β : 1 / β * β = 1 := by field_simp
      rw [h1β, one_smul]
      abel
    -- ‖x(k+1)-xstar‖² = ‖x(k)-xstar‖² - (2/β)⟨g,x(k)-xstar⟩ + (1/β²)‖g‖²
    have h_expand : ‖x (k + 1) - xstar‖ ^ 2 =
        ‖x k - xstar‖ ^ 2 - 2 / β * ⟪g, x k - xstar⟫_ℝ + 1 / β ^ 2 * ‖g‖ ^ 2 := by
      rw [hxstep, show x k - (1 / β) • g - xstar = (x k - xstar) - (1 / β) • g from by abel]
      rw [norm_sub_sq_real, inner_smul_right, real_inner_comm, norm_smul,
          Real.norm_eq_abs, abs_of_pos (by positivity)]
      ring
    -- (1/β²)‖g‖² ≤ (2/β)⟨g,x(k)-xstar⟩
    have hinner_lb' : 1 / (2 * β) * ‖g‖ ^ 2 ≤ ⟪g, x k - xstar⟫_ℝ := hinner_lb
    have h_coeff : 1 / β ^ 2 * ‖g‖ ^ 2 ≤ 2 / β * ⟪g, x k - xstar⟫_ℝ :=
      calc 1 / β ^ 2 * ‖g‖ ^ 2
          = (2 / β) * (1 / (2 * β) * ‖g‖ ^ 2) := by field_simp; ring
        _ ≤ (2 / β) * ⟪g, x k - xstar⟫_ℝ :=
            mul_le_mul_of_nonneg_left hinner_lb' (by positivity)
    linarith [h_expand]
  -- ‖x(k)-xstar‖ ≤ R for all k
  have hdist_bound : ∀ k, ‖x k - xstar‖ ≤ R := by
    intro k
    induction k with
    | zero => exact le_refl _
    | succ n ih =>
      have h := hdist_mono n
      nlinarith [norm_nonneg (x (n+1) - xstar), norm_nonneg (x n - xstar)]
  -- Recurrence: δ(k+1)² ≤ 2βR²·(δ(k)-δ(k+1))
  have hδ_rec : ∀ k, δ (k + 1) ^ 2 ≤ 2 * β * R ^ 2 * (δ k - δ (k + 1)) := by
    intro k
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.7 |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | 10m 0s |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem37.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem37.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_02_01_the_constrained_case.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_02_01_the_constrained_case.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Lemma 3.6](./lemma-3-6.md)
- Next: [Theorem 3.8](./theorem-3-8.md)
