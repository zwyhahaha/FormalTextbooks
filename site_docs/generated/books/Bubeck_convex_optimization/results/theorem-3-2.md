# Theorem 3.2

[Bubeck Convex Optimization](../index.md) / [Chapter 3](../chapters/chapter-3.md) / [Section 3.1](../sections/section-3-1-projected-subgradient-descent-for-lipschitz-functions.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-proved">Proved</span>

**Roadmap context:** <span class="roadmap-pill roadmap-high">High</span> Build a coherent first-order methods track that starts with gradient and subgradient methods, then expands toward strong convexity and acceleration.

## Informal Statement

**Theorem**

The projected subgradient descent method with $\eta = \frac{R}{L \sqrt{t}}$ satisfies 

\[
f\left(\frac{1}{t} \sum_{s=1}^t x_s\right) - f(x^*) \leq \frac{R L}{\sqrt{t}} .
\]

## Lean Formalization

Symbol: `theorem_3_2`

```lean
/-- **Theorem 3.2** (Bubeck §3.1): Projected subgradient descent convergence rate.

With step size η = R/(L√t), the projected subgradient descent satisfies:
  f(1/t Σ_{k=0}^{t-1} x_k) - f(x*) ≤ R·L / √t -/
theorem theorem_3_2
    {𝒳 : Set E} (h𝒳 : Convex ℝ 𝒳)
    {f : E → ℝ} (hf : ConvexOn ℝ 𝒳 f)
    {xstar : E} (hxstar_in : xstar ∈ 𝒳)
    {R L : ℝ} (hR : 0 < R) (hL : 0 < L)
    {t : ℕ} (ht : 0 < t)
    (η : ℝ) (hη_def : η = R / (L * Real.sqrt t)) (hη : 0 < η)
    {x y g : ℕ → E}
    (hx_in : ∀ k, x k ∈ 𝒳)
    (hinit : ‖x 0 - xstar‖ ≤ R)
    (hg : ∀ k < t, HasSubgradientWithinAt f (g k) 𝒳 (x k))
    (hg_bound : ∀ k < t, ‖g k‖ ≤ L)
    (hy : ∀ k < t, y (k + 1) = x k - η • g k)
    (hproj_min : ∀ k < t, ‖y (k + 1) - x (k + 1)‖ = ⨅ w : 𝒳, ‖y (k + 1) - w‖) :
    f ((1 / (t : ℝ)) • ∑ k ∈ range t, x k) - f xstar ≤ R * L / Real.sqrt t := by
  have ht_pos : (0 : ℝ) < t := Nat.cast_pos.mpr ht
  have hsqrt_pos : 0 < Real.sqrt t := Real.sqrt_pos.mpr ht_pos
  -- Step 1: Jensen — f(avg) ≤ (1/t) Σ f(x_k)
  have hJensen : f ((1 / (t : ℝ)) • ∑ k ∈ range t, x k) ≤
      (1 / (t : ℝ)) * ∑ k ∈ range t, f (x k) := by
    have hsum_one : ∑ _k ∈ range t, (1 / (t : ℝ)) = 1 := by
      rw [sum_const, card_range]; simp [nsmul_eq_mul]; field_simp
    have key := hf.map_sum_le (t := range t) (w := fun _ => (1 : ℝ) / ↑t) (p := x)
      (fun _ _ => by positivity) hsum_one (fun k _ => hx_in k)
    have hlhs : (1 / (t : ℝ)) • ∑ k ∈ range t, x k = ∑ k ∈ range t, (1 / (t : ℝ)) • x k :=
      Finset.smul_sum ..
    rw [hlhs]
    exact le_trans key (le_of_eq (by simp only [smul_eq_mul, ← Finset.mul_sum]))
  -- Step 2: algebraic identity
  have hdiff_sum : (1 / (t : ℝ)) * ∑ k ∈ range t, f (x k) - f xstar =
      (1 / (t : ℝ)) * ∑ k ∈ range t, (f (x k) - f xstar) := by
    rw [Finset.sum_sub_distrib]
    simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
    field_simp [ne_of_gt ht_pos]
  -- Step 3: sum bound → average bound
  have hsum := pgd_sum_bound h𝒳 hxstar_in hR hL hη ht hx_in hinit hg hg_bound hy hproj_min
  have havg : (1 / (t : ℝ)) * ∑ k ∈ range t, (f (x k) - f xstar) ≤
      R ^ 2 / (2 * η * ↑t) + η * L ^ 2 / 2 :=
    calc (1 / ↑t) * ∑ k ∈ range t, (f (x k) - f xstar)
        ≤ (1 / ↑t) * (R ^ 2 / (2 * η) + η * L ^ 2 * ↑t / 2) :=
            mul_le_mul_of_nonneg_left hsum (by positivity)
      _ = R ^ 2 / (2 * η * ↑t) + η * L ^ 2 / 2 := by field_simp; ring
  -- Step 4: plug in η = R/(L√t)
  have hfinal : R ^ 2 / (2 * η * ↑t) + η * L ^ 2 / 2 = R * L / Real.sqrt t := by
    set s := Real.sqrt ↑t
    have hs_pos : 0 < s := hsqrt_pos
    have hs_sq : s ^ 2 = (t : ℝ) := Real.sq_sqrt (le_of_lt ht_pos)
    have hs_ne : s ≠ 0 := ne_of_gt hs_pos
    have hL_ne : L ≠ 0 := ne_of_gt hL
    have hR_ne : R ≠ 0 := ne_of_gt hR
    rw [hη_def, show (t : ℝ) = s ^ 2 from hs_sq.symm]
    field_simp [hL_ne, hs_ne, hR_ne]
    ring
  -- Combine
  calc f ((1 / (t : ℝ)) • ∑ k ∈ range t, x k) - f xstar
      ≤ (1 / (t : ℝ)) * ∑ k ∈ range t, f (x k) - f xstar := by linarith [hJensen]
    _ = (1 / (t : ℝ)) * ∑ k ∈ range t, (f (x k) - f xstar) := hdiff_sum
    _ ≤ R ^ 2 / (2 * η * ↑t) + η * L ^ 2 / 2 := havg
    _ = R * L / Real.sqrt t := hfinal
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Theorem 3.2 |
| Proof file status | `present` |
| Tracker status | `proved` |
| Computed status | `proved` |
| Proof time | 60m 0s |
| Lean file | [proofs/Bubeck_convex_optimization/Theorem32.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Theorem32.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/03_01_projected_subgradient_descent_for_lipsch.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/03_01_projected_subgradient_descent_for_lipsch.md) |

## Dependencies

- Reuse Optlib gradient-descent interfaces wherever the book statement is only a wrapper around a stronger library theorem.

## Chapter Blockers

- Several later theorems depend on stronger reusable templates for accelerated arguments.

## Nearby Results

- Previous: [Lemma 3.1](./lemma-3-1.md)
- Next: [Lemma 3.4](./lemma-3-4.md)
