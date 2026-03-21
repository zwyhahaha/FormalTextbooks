import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Convex.Strong
import Mathlib.Analysis.Convex.Jensen
import Optlib.Convex.StronglyConvex
import Optlib.Convex.Subgradient
import proofs.Bubeck_convex_optimization.Lemma31

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open Set InnerProductSpace Finset Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-!
# Theorem 3.9 — Projected Subgradient Descent for Strongly Convex Functions (Bubeck §3.4.1)

Source: papers/Bubeck_convex_optimization/sections/03_04_01_strongly_convex_and_lipschitz_functions.md

Let f be α-strongly convex and L-Lipschitz on 𝒳. Projected subgradient descent with
  η_s = 2/(α*(s+1)) satisfies:
  f(Σ_{s=1}^t (2s/(t(t+1))) x_s) - f(x*) ≤ 2L²/(α*(t+1))

Indexing (0-based): x k = paper's x_{k+1}, η k = 2/(α*(k+2)) = paper's η_{k+1}.
Weighted average: Σ_{k=0}^{t-1} (2*(k+1)/(t*(t+1))) • x k.
-/

/-! ### Auxiliary: telescoping sum -/

private lemma sc_sum_telescoping (a : ℕ → ℝ) (t : ℕ) :
    ∑ k ∈ range t, (a k - a (k + 1)) = a 0 - a t := by
  induction t with
  | zero => simp
  | succ n ih => rw [sum_range_succ, ih]; ring

/-! ### Step 1: Strong convexity first-order condition for subgradients -/

/-- For an α-strongly convex function, any subgradient g satisfies:
    f(y) ≥ f(x) + ⟨g, y-x⟩ + (α/2)‖y-x‖² for all y in the domain. -/
private lemma sc_subgradient_ineq
    {𝒳 : Set E} (h𝒳 : Convex ℝ 𝒳)
    {f : E → ℝ} {α : ℝ} (hα : 0 < α)
    (hsc : StrongConvexOn 𝒳 α f)
    {x y g : E} (hx : x ∈ 𝒳) (hy : y ∈ 𝒳)
    (hg : HasSubgradientWithinAt f g 𝒳 x) :
    f x + ⟪g, y - x⟫_ℝ + α / 2 * ‖y - x‖ ^ 2 ≤ f y := by
  -- Strategy: for any ε > 0, choose t ∈ (0,1) small enough.
  -- Then f(z_t) where z_t = (1-t)•x + t•y gives:
  --   f(z_t) ≥ f(x) + t*⟨g, y-x⟩   (subgradient)
  --   f(z_t) ≤ (1-t)*f(x) + t*f(y) - α/2*(1-t)*t*‖y-x‖²   (strong convexity)
  -- Dividing by t: f(y) ≥ f(x) + ⟨g, y-x⟩ + α/2*(1-t)*‖y-x‖²
  -- Taking ε → 0 via le_of_forall_pos_le_add.
  apply le_of_forall_pos_le_add
  intro ε hε
  -- C = α/2 * ‖y-x‖², choose t to make t*C ≤ ε
  have hC_nn : 0 ≤ α / 2 * ‖y - x‖ ^ 2 := by positivity
  have hCp1 : 0 < α / 2 * ‖y - x‖ ^ 2 + 1 := by linarith
  set t := min (1/2 : ℝ) (ε / (α / 2 * ‖y - x‖ ^ 2 + 1)) with ht_def
  have ht_pos : 0 < t := lt_min (by norm_num) (div_pos hε hCp1)
  have ht_lt1 : t < 1 := lt_of_le_of_lt (min_le_left _ _) (by norm_num)
  have ht1_pos : 0 < 1 - t := by linarith
  -- z = (1-t)•x + t•y ∈ 𝒳
  have hz_in : (1 - t) • x + t • y ∈ 𝒳 :=
    h𝒳 hx hy ht1_pos.le ht_pos.le (by ring)
  -- Simplify z - x = t•(y-x)
  have hzx : (1 - t) • x + t • y - x = t • (y - x) := by
    have : (1 - t) • x = x - t • x := by rw [sub_smul, one_smul]
    rw [this, smul_sub]; abel
  -- Subgradient inequality: f(z) ≥ f(x) + ⟨g, z-x⟩ = f(x) + t*⟨g, y-x⟩
  have hsg : f x + t * ⟪g, y - x⟫_ℝ ≤ f ((1 - t) • x + t • y) := by
    have h := hg _ hz_in
    rw [hzx, inner_smul_right] at h
    exact h
  -- Strong convexity: f(z) ≤ (1-t)*f(x) + t*f(y) - α/2*(1-t)*t*‖y-x‖²
  have hsc_bound : f ((1 - t) • x + t • y) ≤
      (1 - t) * f x + t * f y - α / 2 * (1 - t) * t * ‖y - x‖ ^ 2 := by
    have h := Strongly_Convex_Bound α hsc hx hy ht1_pos ht_pos (by ring)
    rwa [norm_sub_rev] at h
  -- Combine: f(x) + t*D ≤ (1-t)*f(x) + t*f(y) - C*(1-t)*t
  -- Rearrange: t*(f(x) + D + C*(1-t)) ≤ t*f(y) → f(x) + D + C*(1-t) ≤ f(y)
  have hfinal : f x + ⟪g, y - x⟫_ℝ + α / 2 * (1 - t) * ‖y - x‖ ^ 2 ≤ f y := by
    have hcomb := le_trans hsg hsc_bound
    have key : t * (f x + ⟪g, y - x⟫_ℝ + α / 2 * (1 - t) * ‖y - x‖ ^ 2) ≤ t * f y := by
      nlinarith [sq_nonneg ‖y - x‖]
    exact le_of_mul_le_mul_left key ht_pos
  -- α/2*(1-t)*‖y-x‖² ≥ α/2*‖y-x‖² - ε, so conclude
  have ht_eps : t * (α / 2 * ‖y - x‖ ^ 2) ≤ ε := by
    have h1 : t ≤ ε / (α / 2 * ‖y - x‖ ^ 2 + 1) := min_le_right _ _
    have h2 : (α / 2 * ‖y - x‖ ^ 2) / (α / 2 * ‖y - x‖ ^ 2 + 1) ≤ 1 := by
      rw [div_le_one hCp1]; linarith
    calc t * (α / 2 * ‖y - x‖ ^ 2)
        ≤ ε / (α / 2 * ‖y - x‖ ^ 2 + 1) * (α / 2 * ‖y - x‖ ^ 2) :=
            mul_le_mul_of_nonneg_right h1 hC_nn
      _ = ε * ((α / 2 * ‖y - x‖ ^ 2) / (α / 2 * ‖y - x‖ ^ 2 + 1)) := by ring
      _ ≤ ε * 1 := mul_le_mul_of_nonneg_left h2 hε.le
      _ = ε := mul_one _
  linarith

/-! ### Step 2: Per-step bound for strongly convex projected subgradient descent -/

/-- Per-step bound for projected subgradient descent with α-strong convexity:
    f(x_k) - f(x*) ≤ η/2*L² + (1/(2η) - α/2)*‖x_k-x*‖² - 1/(2η)*‖x_{k+1}-x*‖² -/
private lemma pgd_sc_one_step_bound
    {𝒳 : Set E} (h𝒳 : Convex ℝ 𝒳)
    {f : E → ℝ} {α : ℝ} (hα : 0 < α)
    (hsc : StrongConvexOn 𝒳 α f)
    {xstar xk yk1 xk1 gk : E}
    {L η : ℝ} (hη : 0 < η) (hL : 0 < L)
    (hxk_in : xk ∈ 𝒳) (hxstar_in : xstar ∈ 𝒳)
    (hgk : HasSubgradientWithinAt f gk 𝒳 xk)
    (hgk_bound : ‖gk‖ ≤ L)
    (hyk1 : yk1 = xk - η • gk)
    (hxk1_in : xk1 ∈ 𝒳)
    (hxk1_min : ‖yk1 - xk1‖ = ⨅ w : 𝒳, ‖yk1 - w‖) :
    f xk - f xstar ≤ η / 2 * L ^ 2 +
      (1 / (2 * η) - α / 2) * ‖xk - xstar‖ ^ 2 -
      1 / (2 * η) * ‖xk1 - xstar‖ ^ 2 := by
  -- Step 1: Strong convexity subgradient inequality at (xk, xstar)
  -- f(xstar) ≥ f(xk) + ⟨gk, xstar-xk⟩ + α/2*‖xstar-xk‖²
  have hsc_ineq : f xk - f xstar ≤ ⟪gk, xk - xstar⟫_ℝ - α / 2 * ‖xk - xstar‖ ^ 2 := by
    have h := sc_subgradient_ineq h𝒳 hα hsc hxk_in hxstar_in hgk
    have hnorm : α / 2 * ‖xstar - xk‖ ^ 2 = α / 2 * ‖xk - xstar‖ ^ 2 := by
      rw [norm_sub_rev]
    have hC : ⟪gk, xstar - xk⟫_ℝ = -⟪gk, xk - xstar⟫_ℝ := by
      rw [← neg_sub, inner_neg_right]
    linarith
  -- Step 2: Inner product identity ⟨gk, xk-x*⟩ = (1/(2η))(‖xk-x*‖² + η²‖gk‖² - ‖yk1-x*‖²)
  have hstep : xk - yk1 = η • gk := by rw [hyk1]; simp
  have hpolar : ⟪xk - yk1, xk - xstar⟫_ℝ =
      (1 / 2) * (‖xk - yk1‖ ^ 2 + ‖xk - xstar‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) := by
    have h := @norm_sub_sq_real E _ _ (xk - yk1) (xk - xstar)
    have heq : (xk - yk1) - (xk - xstar) = xstar - yk1 := by abel
    rw [heq, norm_sub_rev] at h; linarith
  have hstep_sq : ‖xk - yk1‖ ^ 2 = η ^ 2 * ‖gk‖ ^ 2 := by
    rw [hstep, norm_smul, Real.norm_eq_abs, abs_of_pos hη]; ring
  have hproj : ‖xk1 - xstar‖ ^ 2 ≤ ‖yk1 - xstar‖ ^ 2 := by
    have hpyt := lemma_3_1_pythagorean h𝒳 hxstar_in hxk1_in hxk1_min
    linarith [sq_nonneg ‖yk1 - xk1‖]
  have hgk_eq : gk = (1 / η) • (xk - yk1) := by
    rw [hstep, smul_smul, one_div, inv_mul_cancel₀ (ne_of_gt hη), one_smul]
  have hinner : ⟪gk, xk - xstar⟫_ℝ =
      (1 / (2 * η)) * (‖xk - xstar‖ ^ 2 + η ^ 2 * ‖gk‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) := by
    have h1 : ⟪gk, xk - xstar⟫_ℝ = (1 / η) * ⟪xk - yk1, xk - xstar⟫_ℝ := by
      rw [hgk_eq, inner_smul_left]; simp [RCLike.conj_ofReal]
    rw [h1, hpolar, hstep_sq]; field_simp [ne_of_gt hη]; ring
  -- Step 3: Bound the inner product using ‖gk‖ ≤ L and projection
  have hgk_sq : η ^ 2 * ‖gk‖ ^ 2 ≤ η ^ 2 * L ^ 2 :=
    mul_le_mul_of_nonneg_left (by nlinarith [norm_nonneg gk, hgk_bound]) (sq_nonneg η)
  have hinner_ub : ⟪gk, xk - xstar⟫_ℝ ≤
      (1 / (2 * η)) * (‖xk - xstar‖ ^ 2 - ‖xk1 - xstar‖ ^ 2) + η / 2 * L ^ 2 := by
    rw [hinner]
    have hmid : η ^ 2 * ‖gk‖ ^ 2 + ‖xk1 - xstar‖ ^ 2 - ‖yk1 - xstar‖ ^ 2 ≤ η ^ 2 * L ^ 2 := by
      linarith
    have hmul : 1 / (2 * η) * (η ^ 2 * ‖gk‖ ^ 2 + ‖xk1 - xstar‖ ^ 2 - ‖yk1 - xstar‖ ^ 2) ≤
        1 / (2 * η) * (η ^ 2 * L ^ 2) :=
      mul_le_mul_of_nonneg_left hmid (by positivity)
    have hsimp : 1 / (2 * η) * (η ^ 2 * L ^ 2) = η / 2 * L ^ 2 := by
      field_simp; ring
    linarith
  -- Combine the bounds
  linarith

/-! ### Weight sum identity -/

private lemma sum_range_kp1 (t : ℕ) :
    (∑ k ∈ range t, ((k : ℝ) + 1)) = t * (t + 1) / 2 := by
  induction t with
  | zero => simp
  | succ n ih => rw [sum_range_succ, ih]; push_cast; ring

/-! ### Main theorem -/

/-- **Theorem 3.9** (Bubeck §3.4.1): Projected subgradient descent with step sizes
    η_k = 2/(α*(k+2)) for an α-strongly convex L-Lipschitz function satisfies:
    f(Σ_{k=0}^{t-1} w_k • x_k) - f(x*) ≤ 2L²/(α*(t+1))
    where w_k = 2*(k+1)/(t*(t+1)) are the weights. -/
theorem theorem_3_9
    {𝒳 : Set E} (h𝒳 : Convex ℝ 𝒳)
    {f : E → ℝ}
    {α L : ℝ} (hα : 0 < α) (hL : 0 < L)
    (hsc : StrongConvexOn 𝒳 α f)
    (hconv : ConvexOn ℝ 𝒳 f)
    {x y g : ℕ → E}
    {xstar : E} (hxstar_in : xstar ∈ 𝒳)
    (hx_in : ∀ k, x k ∈ 𝒳)
    (hg : ∀ k, HasSubgradientWithinAt f (g k) 𝒳 (x k))
    (hg_bound : ∀ k, ‖g k‖ ≤ L)
    -- Step size η_k = 2/(α*(k+2)) (paper's η_{k+1} with 0-indexed k)
    (hy : ∀ k, y (k + 1) = x k - (2 / (α * ((k : ℝ) + 2))) • g k)
    (hproj_min : ∀ k, ‖y (k + 1) - x (k + 1)‖ = ⨅ w : 𝒳, ‖y (k + 1) - w‖)
    (hstar : ∀ z ∈ 𝒳, f xstar ≤ f z)
    {t : ℕ} (ht : 0 < t) :
    f (∑ k ∈ range t, (2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1))) • x k) - f xstar ≤
    2 * L ^ 2 / (α * ((t : ℝ) + 1)) := by
  have ht_pos : (0 : ℝ) < t := Nat.cast_pos.mpr ht
  have ht1_pos : (0 : ℝ) < (t : ℝ) + 1 := by linarith
  have htt1_pos : (0 : ℝ) < (t : ℝ) * ((t : ℝ) + 1) := by positivity
  -- Per-step bound: f(x k) - f(x*) ≤ η_k/2*L² + (1/(2η_k)-α/2)*‖xk-x*‖² - 1/(2η_k)*‖x(k+1)-x*‖²
  -- With η_k = 2/(α*(k+2)): η_k/2 = 1/(α*(k+2)), 1/(2η_k) = α*(k+2)/4, 1/(2η_k)-α/2 = α*k/4
  have hstep : ∀ k : ℕ,
      f (x k) - f xstar ≤
      1 / (α * ((k : ℝ) + 2)) * L ^ 2 +
      α * (k : ℝ) / 4 * ‖x k - xstar‖ ^ 2 -
      α * ((k : ℝ) + 2) / 4 * ‖x (k + 1) - xstar‖ ^ 2 := by
    intro k
    have hk2_pos : (0 : ℝ) < (k : ℝ) + 2 := by positivity
    have hη_pos : (0 : ℝ) < 2 / (α * ((k : ℝ) + 2)) := by positivity
    have hraw := pgd_sc_one_step_bound h𝒳 hα hsc hη_pos hL (hx_in k) hxstar_in
      (hg k) (hg_bound k) (hy k) (hx_in (k+1)) (hproj_min k)
    -- Simplify coefficients: η/2 = 1/(α*(k+2)), 1/(2η) = α*(k+2)/4, 1/(2η)-α/2 = α*k/4
    have hne : α * ((k : ℝ) + 2) ≠ 0 := ne_of_gt (mul_pos hα hk2_pos)
    have hc1 : (2 / (α * ((k : ℝ) + 2))) / 2 * L ^ 2 =
        1 / (α * ((k : ℝ) + 2)) * L ^ 2 := by
      congr 1; field_simp [hne]; ring
    have hc2 : 1 / (2 * (2 / (α * ((k : ℝ) + 2)))) = α * ((k : ℝ) + 2) / 4 := by
      have hx_ne : 2 * (2 / (α * ((k : ℝ) + 2))) ≠ 0 := by positivity
      rw [div_eq_iff hx_ne]
      field_simp [hne]; ring
    have hc3 : α * ((k : ℝ) + 2) / 4 - α / 2 = α * (k : ℝ) / 4 := by ring
    rw [hc2, hc3] at hraw
    linarith [hc1]
  -- Multiply by (k+1): (k+1)*(f(x k)-f(x*)) ≤ L²/α + α/4*(k*(k+1)*‖xk-x*‖² - (k+1)*(k+2)*‖x(k+1)-x*‖²)
  -- This uses (k+1)/(α*(k+2)) ≤ 1/α.
  have hstep' : ∀ k : ℕ,
      ((k : ℝ) + 1) * (f (x k) - f xstar) ≤
      L ^ 2 / α +
      α / 4 * ((k : ℝ) * ((k : ℝ) + 1) * ‖x k - xstar‖ ^ 2 -
               ((k : ℝ) + 1) * ((k : ℝ) + 2) * ‖x (k + 1) - xstar‖ ^ 2) := by
    intro k
    have hk2 : (0 : ℝ) < (k : ℝ) + 2 := by positivity
    have hkp1_pos : (0 : ℝ) < (k : ℝ) + 1 := by positivity
    have hsk := hstep k
    -- Multiply by (k+1)
    have hmul := mul_le_mul_of_nonneg_left hsk hkp1_pos.le
    -- (k+1)/(α*(k+2)) ≤ 1/α since k+1 ≤ k+2
    have hfrac : ((k : ℝ) + 1) / (α * ((k : ℝ) + 2)) ≤ 1 / α := by
      rw [div_le_div_iff (by positivity) (by positivity)]
      nlinarith [hα.le]
    have hfrac_L : ((k : ℝ) + 1) / (α * ((k : ℝ) + 2)) * L ^ 2 ≤ L ^ 2 / α := by
      have h := mul_le_mul_of_nonneg_right hfrac (sq_nonneg L)
      linarith [show (1 : ℝ) / α * L ^ 2 = L ^ 2 / α from by field_simp [ne_of_gt hα]]
    have hmul3 : ((k : ℝ) + 1) * (f (x k) - f xstar) ≤
        ((k : ℝ) + 1) / (α * ((k : ℝ) + 2)) * L ^ 2 +
        α * (k : ℝ) * ((k : ℝ) + 1) / 4 * ‖x k - xstar‖ ^ 2 -
        α * ((k : ℝ) + 1) * ((k : ℝ) + 2) / 4 * ‖x (k + 1) - xstar‖ ^ 2 := by
      have h := mul_le_mul_of_nonneg_left hsk hkp1_pos.le
      linarith [show ((k : ℝ) + 1) * (1 / (α * ((k : ℝ) + 2)) * L ^ 2 +
          α * ↑k / 4 * ‖x k - xstar‖ ^ 2 - α * (↑k + 2) / 4 * ‖x (k + 1) - xstar‖ ^ 2) =
          ((k : ℝ) + 1) / (α * ((k : ℝ) + 2)) * L ^ 2 +
          α * ↑k * (↑k + 1) / 4 * ‖x k - xstar‖ ^ 2 -
          α * (↑k + 1) * (↑k + 2) / 4 * ‖x (k + 1) - xstar‖ ^ 2 from by ring]
    linarith [hfrac_L, hmul3]
  -- Define a k = k*(k+1)*‖x k - x*‖² for telescoping
  set a : ℕ → ℝ := fun k => (k : ℝ) * ((k : ℝ) + 1) * ‖x k - xstar‖ ^ 2
  -- Rewrite hstep' using a
  have htelescope : ∀ k : ℕ,
      ((k : ℝ) + 1) * (f (x k) - f xstar) ≤
      L ^ 2 / α + α / 4 * (a k - a (k + 1)) := by
    intro k
    have := hstep' k
    have heq : (k : ℝ) * ((k : ℝ) + 1) * ‖x k - xstar‖ ^ 2 -
               ((k : ℝ) + 1) * ((k : ℝ) + 2) * ‖x (k+1) - xstar‖ ^ 2 = a k - a (k+1) := by
      simp only [a]; push_cast; ring
    linarith [heq ▸ this]
  -- Sum from k=0 to t-1
  have ha0 : a 0 = 0 := by simp [a]
  have hat_nn : 0 ≤ a t := by simp [a]; positivity
  -- Σ (k+1)*(f(x k) - f(x*)) ≤ t * L²/α + α/4*(a 0 - a t) ≤ t * L²/α
  have hsum : ∑ k ∈ range t, ((k : ℝ) + 1) * (f (x k) - f xstar) ≤ t * L ^ 2 / α := by
    have hle : ∑ k ∈ range t, ((k : ℝ) + 1) * (f (x k) - f xstar) ≤
        t * (L ^ 2 / α) + α / 4 * (a 0 - a t) := by
      calc ∑ k ∈ range t, ((k : ℝ) + 1) * (f (x k) - f xstar)
          ≤ ∑ k ∈ range t, (L ^ 2 / α + α / 4 * (a k - a (k + 1))) :=
              sum_le_sum fun k _ => htelescope k
        _ = t * (L ^ 2 / α) + α / 4 * (a 0 - a t) := by
              rw [sum_add_distrib, ← mul_sum, sc_sum_telescoping, sum_const, card_range, nsmul_eq_mul]
    have hteq : (t : ℝ) * (L ^ 2 / α) = (t : ℝ) * L ^ 2 / α := by ring
    linarith [ha0 ▸ hle, mul_nonneg (by positivity : (0:ℝ) ≤ α / 4) hat_nn, hteq]
  -- Weights w k = 2*(k+1)/(t*(t+1)) sum to 1
  have hw_pos : ∀ k ∈ range t, 0 < 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) := by
    intro k _; positivity
  have hw_sum : ∑ k ∈ range t, 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) = 1 := by
    simp_rw [show ∀ k : ℕ, 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) =
        2 / ((t : ℝ) * ((t : ℝ) + 1)) * ((k : ℝ) + 1) from fun k => by ring]
    rw [← Finset.mul_sum, sum_range_kp1]
    field_simp [ne_of_gt htt1_pos]
  -- Jensen's inequality: f(Σ w_k • x_k) ≤ Σ w_k * f(x_k)
  have hJensen : f (∑ k ∈ range t, (2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1))) • x k) ≤
      ∑ k ∈ range t, 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) * f (x k) := by
    have key := hconv.map_sum_le (t := range t)
      (w := fun k => 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)))
      (p := x) (fun k hk => (hw_pos k hk).le) hw_sum (fun k _ => hx_in k)
    simp only [smul_eq_mul] at key
    exact key
  -- Σ w_k * f(x_k) - f(x*) = (2/(t*(t+1))) * Σ (k+1)*(f(x k) - f(x*)) ≤ 2*L²/(α*(t+1))
  have hweighted : ∑ k ∈ range t, 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) * f (x k) -
      f xstar ≤ 2 * L ^ 2 / (α * ((t : ℝ) + 1)) := by
    -- Rewrite as weighted sum of (f(x k) - f(x*))
    have hrw : ∑ k ∈ range t, 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) * f (x k) -
        f xstar =
        2 / ((t : ℝ) * ((t : ℝ) + 1)) *
        ∑ k ∈ range t, ((k : ℝ) + 1) * (f (x k) - f xstar) := by
      have hfx_sum' : f xstar = ∑ k ∈ range t, 2 * ((k : ℝ) + 1) / ((t : ℝ) * ((t : ℝ) + 1)) * f xstar := by
        rw [← sum_mul, hw_sum, one_mul]
      conv_lhs => rw [hfx_sum']
      rw [← sum_sub_distrib]
      conv_rhs => rw [Finset.mul_sum]
      congr 1; ext k; ring
    rw [hrw]
    calc 2 / ((t : ℝ) * ((t : ℝ) + 1)) * ∑ k ∈ range t, ((k : ℝ) + 1) * (f (x k) - f xstar)
        ≤ 2 / ((t : ℝ) * ((t : ℝ) + 1)) * (t * L ^ 2 / α) := by
            apply mul_le_mul_of_nonneg_left hsum; positivity
      _ = 2 * L ^ 2 / (α * ((t : ℝ) + 1)) := by field_simp; ring
  linarith
