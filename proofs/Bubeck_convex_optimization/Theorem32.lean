import Mathlib.Analysis.InnerProductSpace.Projection
import Mathlib.Analysis.Convex.Jensen
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Optlib.Convex.Subgradient
import proofs.Bubeck_convex_optimization.Lemma31

/-!
# Theorem 3.2 — Projected Subgradient Descent Convergence (Bubeck §3.1)

Source: papers/Bubeck_convex_optimization/sections/03_01_projected_subgradient_descent_for_lipsch.md

The projected subgradient descent method with η = R/(L√t) satisfies
  f(1/t Σ_{k=0}^{t-1} x_k) - f(x*) ≤ R·L / √t
-/

set_option linter.unusedSectionVars false

open InnerProductSpace Finset Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-! ### Per-step descent bound -/

/-- Per-step bound for projected subgradient descent:
  f(x_k) - f(x*) ≤ (1/(2η))(‖x_k - x*‖² - ‖x_{k+1} - x*‖²) + (η/2)L² -/
theorem pgd_one_step_bound
    {𝒳 : Set E} (h𝒳 : Convex ℝ 𝒳)
    {f : E → ℝ}
    {xstar xk yk1 xk1 gk : E}
    {L η : ℝ} (hη : 0 < η) (hL : 0 < L)
    (_hxk_in : xk ∈ 𝒳) (hxstar_in : xstar ∈ 𝒳)
    (hgk : HasSubgradientWithinAt f gk 𝒳 xk)
    (hgk_bound : ‖gk‖ ≤ L)
    (hyk1 : yk1 = xk - η • gk)
    (hxk1_in : xk1 ∈ 𝒳)
    (hxk1_min : ‖yk1 - xk1‖ = ⨅ w : 𝒳, ‖yk1 - w‖) :
    f xk - f xstar ≤ (1 / (2 * η)) * (‖xk - xstar‖ ^ 2 - ‖xk1 - xstar‖ ^ 2) + η / 2 * L ^ 2 := by
  -- 1. Subgradient inequality: f(xk) - f(x*) ≤ ⟨gk, xk - x*⟩
  have hsg : f xk - f xstar ≤ ⟪gk, xk - xstar⟫_ℝ := by
    have h := hgk xstar hxstar_in
    linarith [show ⟪gk, xstar - xk⟫_ℝ = -⟪gk, xk - xstar⟫_ℝ from by
      rw [← neg_sub, inner_neg_right]]
  -- 2. xk - yk1 = η • gk
  have hstep : xk - yk1 = η • gk := by rw [hyk1]; simp
  -- 3. Polarization: ⟨xk - yk1, xk - x*⟩ = (1/2)(‖xk-yk1‖² + ‖xk-x*‖² - ‖yk1-x*‖²)
  have hpolar : ⟪xk - yk1, xk - xstar⟫_ℝ =
      (1 / 2) * (‖xk - yk1‖ ^ 2 + ‖xk - xstar‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) := by
    have h := @norm_sub_sq_real E _ _ (xk - yk1) (xk - xstar)
    -- h : ‖(xk-yk1)-(xk-xstar)‖² = ‖xk-yk1‖² - 2⟨xk-yk1,xk-xstar⟩ + ‖xk-xstar‖²
    have heq : (xk - yk1) - (xk - xstar) = xstar - yk1 := by abel
    rw [heq, norm_sub_rev] at h
    linarith
  -- 4. ‖xk - yk1‖² = η²‖gk‖²
  have hstep_sq : ‖xk - yk1‖ ^ 2 = η ^ 2 * ‖gk‖ ^ 2 := by
    rw [hstep, norm_smul, Real.norm_eq_abs, abs_of_pos hη]; ring
  -- 5. Projection bound: ‖xk1 - x*‖² ≤ ‖yk1 - x*‖²
  have hproj : ‖xk1 - xstar‖ ^ 2 ≤ ‖yk1 - xstar‖ ^ 2 := by
    have hpyt := lemma_3_1_pythagorean h𝒳 hxstar_in hxk1_in hxk1_min
    linarith [sq_nonneg ‖yk1 - xk1‖]
  -- 6. Inner product: ⟨gk, xk - x*⟩ = (1/(2η))(‖xk-x*‖² + η²‖gk‖² - ‖yk1-x*‖²)
  have hinner : ⟪gk, xk - xstar⟫_ℝ =
      (1 / (2 * η)) * (‖xk - xstar‖ ^ 2 + η ^ 2 * ‖gk‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) := by
    -- gk = (1/η) • (xk - yk1)
    have hgk_eq : gk = (1 / η) • (xk - yk1) := by
      rw [hstep, smul_smul, one_div, inv_mul_cancel₀ (ne_of_gt hη), one_smul]
    -- ⟨gk, xk - x*⟩ = (1/η) * ⟨xk - yk1, xk - x*⟩
    have h1 : ⟪gk, xk - xstar⟫_ℝ = (1 / η) * ⟪xk - yk1, xk - xstar⟫_ℝ := by
      rw [hgk_eq, inner_smul_left]
      simp [RCLike.conj_ofReal]
    rw [h1, hpolar, hstep_sq]
    field_simp [ne_of_gt hη]; ring
  -- 7. Combine using hproj (projection) and hgk_bound (gradient bound)
  have hgk_sq : η ^ 2 * ‖gk‖ ^ 2 ≤ η ^ 2 * L ^ 2 :=
    mul_le_mul_of_nonneg_left (by nlinarith [norm_nonneg gk, hgk_bound]) (sq_nonneg η)
  have hrhs : η / 2 * L ^ 2 = (1 / (2 * η)) * (η ^ 2 * L ^ 2) := by
    field_simp; ring
  linarith [mul_le_mul_of_nonneg_left (show η ^ 2 * ‖gk‖ ^ 2 + ‖xk1 - xstar‖ ^ 2 -
        ‖yk1 - xstar‖ ^ 2 ≤ η ^ 2 * L ^ 2 from by linarith)
      (by positivity : (0 : ℝ) ≤ 1 / (2 * η)),
    show (1 / (2 * η)) * (‖xk - xstar‖ ^ 2 + η ^ 2 * ‖gk‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) -
        (1 / (2 * η)) * (‖xk - xstar‖ ^ 2 - ‖xk1 - xstar‖ ^ 2) =
        (1 / (2 * η)) * (η ^ 2 * ‖gk‖ ^ 2 + ‖xk1 - xstar‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) from by ring,
    hinner, hrhs]

/-! ### Telescoping sum -/

private lemma sum_telescoping (a : ℕ → ℝ) (t : ℕ) :
    ∑ k ∈ range t, (a k - a (k + 1)) = a 0 - a t := by
  induction t with
  | zero => simp
  | succ n ih => rw [sum_range_succ, ih]; ring

/-! ### Summation bound -/

theorem pgd_sum_bound
    {𝒳 : Set E} (h𝒳 : Convex ℝ 𝒳)
    {f : E → ℝ}
    {xstar : E} (hxstar_in : xstar ∈ 𝒳)
    {R L η : ℝ} (hR : 0 < R) (hL : 0 < L) (hη : 0 < η)
    {t : ℕ} (_ht : 0 < t)
    {x y g : ℕ → E}
    (hx_in : ∀ k, x k ∈ 𝒳)
    (hinit : ‖x 0 - xstar‖ ≤ R)
    (hg : ∀ k < t, HasSubgradientWithinAt f (g k) 𝒳 (x k))
    (hg_bound : ∀ k < t, ‖g k‖ ≤ L)
    (hy : ∀ k < t, y (k + 1) = x k - η • g k)
    (hproj_min : ∀ k < t, ‖y (k + 1) - x (k + 1)‖ = ⨅ w : 𝒳, ‖y (k + 1) - w‖) :
    ∑ k ∈ range t, (f (x k) - f xstar) ≤ R ^ 2 / (2 * η) + η * L ^ 2 * t / 2 := by
  -- Per-step bounds
  have hstep : ∀ k < t, f (x k) - f xstar ≤
      (1 / (2 * η)) * (‖x k - xstar‖ ^ 2 - ‖x (k + 1) - xstar‖ ^ 2) + η / 2 * L ^ 2 :=
    fun k hkt => pgd_one_step_bound h𝒳 hη hL (hx_in k) hxstar_in
      (hg k hkt) (hg_bound k hkt) (hy k hkt) (hx_in (k + 1)) (hproj_min k hkt)
  -- Sum the per-step bounds
  have hsum_ub : ∑ k ∈ range t, (f (x k) - f xstar) ≤
      ∑ k ∈ range t, ((1 / (2 * η)) * (‖x k - xstar‖ ^ 2 - ‖x (k + 1) - xstar‖ ^ 2) +
                      η / 2 * L ^ 2) :=
    sum_le_sum (fun k hk => hstep k (mem_range.mp hk))
  -- Telescope
  have htelescope : ∑ k ∈ range t, (1 / (2 * η)) *
      (‖x k - xstar‖ ^ 2 - ‖x (k + 1) - xstar‖ ^ 2) ≤ R ^ 2 / (2 * η) := by
    rw [← mul_sum, show R ^ 2 / (2 * η) = 1 / (2 * η) * R ^ 2 from by ring]
    apply mul_le_mul_of_nonneg_left _ (by positivity)
    rw [sum_telescoping]
    nlinarith [sq_nonneg ‖x t - xstar‖, norm_nonneg (x 0 - xstar)]
  -- Constant part
  have hconst : ∑ _k ∈ range t, (η / 2 * L ^ 2) = η * L ^ 2 * t / 2 := by
    simp only [sum_const, card_range, nsmul_eq_mul]; ring
  calc ∑ k ∈ range t, (f (x k) - f xstar)
      ≤ ∑ k ∈ range t, ((1 / (2 * η)) * (‖x k - xstar‖ ^ 2 - ‖x (k + 1) - xstar‖ ^ 2) +
                          η / 2 * L ^ 2) := hsum_ub
    _ = ∑ k ∈ range t, (1 / (2 * η)) * (‖x k - xstar‖ ^ 2 - ‖x (k + 1) - xstar‖ ^ 2) +
        ∑ _k ∈ range t, (η / 2 * L ^ 2) := sum_add_distrib
    _ ≤ R ^ 2 / (2 * η) + η * L ^ 2 * t / 2 := add_le_add htelescope (le_of_eq hconst)

/-! ### Main theorem -/

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
