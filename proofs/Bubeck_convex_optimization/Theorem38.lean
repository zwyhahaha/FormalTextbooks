import Mathlib.Analysis.MeanInequalities
import Mathlib.Topology.Algebra.Module.Basic
import Optlib.Function.Lsmooth

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open Set

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-!
# Theorem 3.8 — Frank-Wolfe / Conditional Gradient Descent (Bubeck §3.3)

Source: papers/Bubeck_convex_optimization/sections/03_03_conditional_gradient_descent_aka_frank_w.md

Let f be a convex and β-smooth function w.r.t. some norm ‖·‖, R = sup_{x,y ∈ X} ‖x-y‖,
and γ_s = 2/(s+1) for s ≥ 1. Frank-Wolfe update:
  y_t ∈ argmin_{y ∈ X} f'(x_t)(y),  x_{t+1} = (1-γ_t) x_t + γ_t y_t.
Then for any t ≥ 2: f(x_t) - f(x*) ≤ 2βR²/(t+1).
-/

/-! ### Pure recurrence bound

If δ satisfies the Frank-Wolfe recurrence δ(s+1) ≤ (1-γs)·δ(s) + β/2·γs²·R²
with γs = 2/(s+2) (0-indexed), then δ(t+1) ≤ 2βR²/(t+3) for all t : ℕ.
(Lean 0-index: t+1 ↔ paper step t+2, bound 2βR²/(t+3) = 2βR²/(paper (t+2)+1).) -/

private lemma fw_recurrence_bound
    (δ : ℕ → ℝ) (β R : ℝ) (hβ : 0 < β) (hR : 0 ≤ R)
    (hrec : ∀ s : ℕ, δ (s + 1) ≤ (1 - 2 / ((s : ℝ) + 2)) * δ s +
      β / 2 * (2 / ((s : ℝ) + 2)) ^ 2 * R ^ 2) :
    ∀ t : ℕ, δ (t + 1) ≤ 2 * β * R ^ 2 / ((t : ℝ) + 3) := by
  intro t
  induction t with
  | zero =>
    -- s=0: δ(1) ≤ (1-1)*δ(0) + β/2*1*R² = β/2*R²
    -- Need: δ(1) ≤ 2βR²/3   (β/2 ≤ 2β/3 since 1/2 ≤ 2/3)
    have h0 := hrec 0
    simp only [Nat.cast_zero, zero_add] at h0
    norm_num at h0
    -- h0 : δ 1 ≤ β / 2 * R ^ 2
    have hβR := mul_nonneg hβ.le (sq_nonneg R)
    simp only [Nat.cast_zero, zero_add]
    norm_num
    nlinarith
  | succ k ih =>
    -- IH: δ(k+1) ≤ 2βR²/(k+3)
    -- Recurrence at k+1: δ(k+2) ≤ (1-2/(k+3))*δ(k+1) + β/2*(2/(k+3))²*R²
    -- Arithmetic inductive step: 2βR²(k+2)/(k+3)² ≤ 2βR²/(k+4)
    have hk3_pos : (0 : ℝ) < (k : ℝ) + 3 := by positivity
    have hk4_pos : (0 : ℝ) < (k : ℝ) + 4 := by positivity
    have hβR := mul_nonneg hβ.le (sq_nonneg R)
    -- Normalize hrec at k+1: cast ↑(k+1) + 2 = ↑k + 3
    have hrk : δ (k + 2) ≤ (1 - 2 / ((k : ℝ) + 3)) * δ (k + 1) +
        β / 2 * (2 / ((k : ℝ) + 3)) ^ 2 * R ^ 2 := by
      have h := hrec (k + 1)
      simp only [Nat.cast_add, Nat.cast_one] at h
      have heq : (↑k : ℝ) + 1 + 2 = ↑k + 3 := by ring
      rw [heq] at h
      exact h
    have hfactor_nn : (0 : ℝ) ≤ 1 - 2 / ((k : ℝ) + 3) := by
      have hk_nn : (0 : ℝ) ≤ k := Nat.cast_nonneg k
      rw [sub_nonneg, div_le_one hk3_pos]; linarith
    -- Apply IH to bound δ(k+1) in the recurrence
    have h1 : δ (k + 2) ≤ (1 - 2 / ((k : ℝ) + 3)) * (2 * β * R ^ 2 / ((k : ℝ) + 3)) +
        β / 2 * (2 / ((k : ℝ) + 3)) ^ 2 * R ^ 2 := by
      have hmul : (1 - 2 / ((k : ℝ) + 3)) * δ (k + 1) ≤
          (1 - 2 / ((k : ℝ) + 3)) * (2 * β * R ^ 2 / ((k : ℝ) + 3)) :=
        mul_le_mul_of_nonneg_left ih hfactor_nn
      linarith [hrk]
    -- Arithmetic: LHS = 2βR²(k+2)/(k+3)² ≤ 2βR²/(k+4)
    have h2 : (1 - 2 / ((k : ℝ) + 3)) * (2 * β * R ^ 2 / ((k : ℝ) + 3)) +
        β / 2 * (2 / ((k : ℝ) + 3)) ^ 2 * R ^ 2 ≤ 2 * β * R ^ 2 / ((k : ℝ) + 4) := by
      have hk3sq_pos : (0 : ℝ) < ((k : ℝ) + 3) ^ 2 := by positivity
      rw [show (1 - 2 / ((k : ℝ) + 3)) * (2 * β * R ^ 2 / ((k : ℝ) + 3)) +
          β / 2 * (2 / ((k : ℝ) + 3)) ^ 2 * R ^ 2 =
          2 * β * R ^ 2 * ((k : ℝ) + 2) / ((k : ℝ) + 3) ^ 2 from by
        field_simp; ring]
      rw [div_le_div_iff hk3sq_pos hk4_pos]
      have hk_nn : (0 : ℝ) ≤ k := Nat.cast_nonneg k
      nlinarith [hβR, hk_nn]
    -- Combine: δ(k+2) ≤ 2βR²/(k+4) = 2βR²/(↑(k+1)+3)
    have h3 : 2 * β * R ^ 2 / ((k : ℝ) + 4) = 2 * β * R ^ 2 / ((↑(k + 1) : ℝ) + 3) := by
      push_cast; ring
    linarith [h1, h2, h3.ge]

/-! ### Main theorem -/

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
