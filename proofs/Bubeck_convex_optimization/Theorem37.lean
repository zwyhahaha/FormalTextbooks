import Optlib.Function.Lsmooth
import Mathlib.Analysis.InnerProductSpace.Projection
import proofs.Bubeck_convex_optimization.Lemma36

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open InnerProductSpace Set

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E] [CompleteSpace E]

/-!
# Theorem 3.7 — Projected Gradient Descent for β-smooth Convex Functions (Bubeck §3.2.1)

Source: papers/Bubeck_convex_optimization/sections/03_02_01_the_constrained_case.md

Let f be convex and β-smooth on X. Projected gradient descent with η = 1/β satisfies
  f(x(t)) - f(x*) ≤ (3β‖x(0) - x*‖² + (f(x(0)) - f(x*))) / (t + 1)
-/

/-! ### g(x) = x(x+M) is increasing for x ≥ 0 -/

private lemma g_mono_bound {d c M : ℝ} (hd : 0 ≤ d) (hc : 0 ≤ c) (hM : 0 < M)
    (h : d ^ 2 + M * d ≤ c ^ 2 + M * c) : d ≤ c := by
  have h1 : (d - c) * (d + c + M) ≤ 0 := by nlinarith
  have h2 : 0 < d + c + M := by linarith
  rcases le_or_lt (d - c) 0 with h | h
  · linarith
  · exact absurd (mul_pos h h2) (not_lt.mpr h1)

/-! ### Recurrence lemma: δ(n+1)² ≤ M(δ(n)-δ(n+1)) implies δ(n) ≤ A/(n+1) -/

private lemma recurrence_to_bound
    (δ : ℕ → ℝ) (M A : ℝ) (hM : 0 < M)
    (hδ_nn : ∀ n, 0 ≤ δ n)
    (hδ_rec : ∀ n, δ (n + 1) ^ 2 ≤ M * (δ n - δ (n + 1)))
    (hA_def : A = 3 / 2 * M + δ 0) :
    ∀ n, δ n ≤ A / (↑n + 1) := by
  have hA_pos : 0 < A := by nlinarith [hδ_nn 0]
  have hδ_mono : ∀ n, δ (n + 1) ≤ δ n := fun n => by
    nlinarith [hδ_rec n, hδ_nn (n + 1), sq_nonneg (δ (n + 1))]
  intro n
  induction n with
  | zero =>
    simp only [Nat.cast_zero, zero_add, div_one]
    linarith [mul_pos (show (0:ℝ) < 3/2 by norm_num) hM]
  | succ k ih =>
    -- Goal: δ(k+1) ≤ A/(↑(k+1)+1) = A/(↑k+2)
    have hk_cast : (↑(k + 1) : ℝ) + 1 = ↑k + 2 := by push_cast; ring
    rw [hk_cast]
    have hk2_pos : (0:ℝ) < ↑k + 2 := by positivity
    have hk1_pos : (0:ℝ) < ↑k + 1 := by positivity
    have hd_nn : 0 ≤ δ (k + 1) := hδ_nn (k + 1)
    have hc_nn : 0 ≤ A / (↑k + 2) := by positivity
    -- δ(k+1)² + M·δ(k+1) ≤ M·δ(k)
    have hstep : δ (k + 1) ^ 2 + M * δ (k + 1) ≤ M * δ k := by
      have := hδ_rec k; nlinarith [sq_nonneg (δ (k + 1))]
    -- Suffices: M·δ(k) ≤ (A/(k+2))² + M·(A/(k+2))
    suffices hgc : M * δ k ≤ (A / (↑k + 2)) ^ 2 + M * (A / (↑k + 2)) from
      g_mono_bound hd_nn hc_nn hM (le_trans hstep hgc)
    rcases Nat.eq_zero_or_pos k with rfl | hk_pos
    · -- k=0: need M·δ(0) ≤ (A/2)² + M·(A/2)
      norm_num only
      -- Goal: M * δ 0 ≤ (A / 2)^2 + M * (A / 2)
      -- This is 21M²/16 + M·δ(0)/4 + δ(0)²/4 ≥ 0 after subst A = 3M/2+δ(0)
      nlinarith [mul_pos hM hM, sq_nonneg (A - M), hA_def, hδ_nn 0,
                 mul_nonneg hM.le (hδ_nn 0), sq_nonneg (δ 0)]
    · -- k≥1: use IH δ(k) ≤ A/(k+1), and A·(k+1) ≥ M·(k+2)
      have hAM : A * (↑k + 1) ≥ M * (↑k + 2) := by
        have hk1_nn : (1:ℝ) ≤ ↑k := by exact_mod_cast hk_pos
        nlinarith [hδ_nn 0, mul_pos hM (show (0:ℝ) < ↑k by exact_mod_cast hk_pos)]
      -- M·δ(k) ≤ M·A/(k+1)
      have hbound : M * δ k ≤ M * A / (↑k + 1) :=
        calc M * δ k ≤ M * (A / (↑k + 1)) := mul_le_mul_of_nonneg_left ih hM.le
          _ = M * A / (↑k + 1) := (mul_div_assoc M A _).symm
      -- M·A/(k+1) ≤ (A/(k+2))² + M·(A/(k+2))
      have hgc' : M * A / (↑k + 1) ≤ (A / (↑k + 2)) ^ 2 + M * (A / (↑k + 2)) := by
        have key : M * A * (↑k + 2) ≤ A ^ 2 * (↑k + 1) := by
          have := mul_nonneg hA_pos.le (show (0:ℝ) ≤ A * (↑k + 1) - M * (↑k + 2) from by linarith)
          nlinarith
        have rhs_eq : (A / (↑k + 2)) ^ 2 + M * (A / (↑k + 2)) =
            (A ^ 2 + M * A * (↑k + 2)) / (↑k + 2) ^ 2 := by field_simp; ring
        rw [rhs_eq, div_le_div_iff hk1_pos (pow_pos hk2_pos 2)]
        nlinarith [mul_pos hM hA_pos, sq_pos_of_pos hk2_pos, key]
      linarith

/-! ### Main theorem -/

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
    set u := ‖β • (x k - x (k + 1))‖ with hu_def
    have hu2 : u ^ 2 ≤ 2 * β * (δ k - δ (k + 1)) :=
      calc u ^ 2 = 2 * β * (1 / (2 * β) * u ^ 2) := by field_simp
        _ ≤ 2 * β * (δ k - δ (k + 1)) :=
            mul_le_mul_of_nonneg_left (by have := hfunc_desc k; linarith) (by positivity)
    have hbound : δ (k + 1) ≤ u * R :=
      le_trans (hsubopt k) (mul_le_mul_of_nonneg_left (hdist_bound k) (norm_nonneg _))
    have hu2R : δ (k + 1) ^ 2 ≤ u ^ 2 * R ^ 2 := by
      have hnn := hδ_nn (k + 1)
      have hmul := mul_le_mul hbound hbound hnn (mul_nonneg (norm_nonneg _) (norm_nonneg _))
      nlinarith
    nlinarith [mul_le_mul_of_nonneg_right hu2 (sq_nonneg R)]
  -- Apply recurrence bound
  have hR_nn : 0 ≤ R := norm_nonneg _
  rcases hR_nn.eq_or_gt with hR0 | hR_pos
  · -- R = 0: both x(0) and x(t) equal xstar
    have hR_eq : R = 0 := hR0
    have eq_xstar : ∀ k, x k = xstar := fun k => by
      have := hdist_bound k
      rw [hR_eq] at this
      exact sub_eq_zero.mp (norm_eq_zero.mp (le_antisymm this (norm_nonneg _)))
    simp only [eq_xstar t, eq_xstar 0, sub_self, zero_le_one]
    apply div_nonneg _ (by positivity)
    have : R = 0 := hR_eq
    nlinarith [sq_nonneg R, hβ.le]
  · -- R > 0: apply recurrence_to_bound
    have hM_pos : 0 < 2 * β * R ^ 2 := by positivity
    have hδ_rec2 : ∀ k, δ (k + 1) ^ 2 ≤ (2 * β * R ^ 2) * (δ k - δ (k + 1)) :=
      fun k => by linarith [hδ_rec k]
    have hA_eq : 3 * β * R ^ 2 + δ 0 = 3 / 2 * (2 * β * R ^ 2) + δ 0 := by ring
    have hbound := recurrence_to_bound δ (2 * β * R ^ 2) (3 * β * R ^ 2 + δ 0)
      hM_pos hδ_nn hδ_rec2 (by linarith [hA_eq])
    simp only [δ] at hbound ⊢
    exact hbound t
