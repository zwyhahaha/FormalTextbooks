/-
# Cone Ratio Computation and 1D Grunbaum Inequality

Part of the Grunbaum theorem proof infrastructure (Lemma 2.2, Bubeck section 2.1).

## Cone ratio computation
For the cone profile v(t) = (n - t)^(n-1) on [-1, n]:
  - integral_cone_positive: ∫_0^n (n - t)^(n-1) dt = n^(n-1)
  - integral_cone_total: ∫_{-1}^n (n - t)^(n-1) dt = (n+1)^n / n
  - cone_ratio: ratio = (n/(n+1))^n

## 1D Grunbaum inequality
For a concave function phi with centroid at 0, the ratio of integrals
over [0,b] vs [a,b] is at least (n/(n+1))^n. (sorry for variational step)

Source: papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md
-/
import Mathlib.Analysis.SpecialFunctions.Integrals
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.Convex.Function

set_option linter.unusedSectionVars false
set_option maxHeartbeats 800000

open MeasureTheory Real Set intervalIntegral

noncomputable section

/-!
## Substitution helper

We need: ∫_{a}^{b} (c - t)^k dt = ∫_{c-b}^{c-a} u^k du
via the substitution u = c - t (i.e. t = c - u, dt = -du).
This follows from `integral_comp_sub_right`.
-/

/-- Substitution: ∫_a^b (c - t)^k dt = ∫_{c-b}^{c-a} u^k du -/
lemma integral_pow_sub_right (c : ℝ) (k : ℕ) (a b : ℝ) :
    ∫ t in a..b, (c - t) ^ k = ∫ u in (c - b)..(c - a), u ^ k := by
  -- Use integral_comp_sub_right with f(x) = x^k and d = c
  -- integral_comp_sub_right says: ∫ x in a..b, f(x - d) = ∫ x in (a-d)..(b-d), f(x)
  -- We want ∫ t in a..b, (c - t)^k.
  -- Write c - t = -(t - c), so (c - t)^k = (-(t - c))^k = (-1)^k * (t - c)^k.
  -- Actually, let's use a direct substitution approach.
  -- integral_comp_sub_left: ∫ x in a..b, f (d - x) = ∫ x in (d-b)..(d-a), f x
  rw [show (fun t => (c - t) ^ k) = (fun t => (· ^ k) (c - t)) from rfl]
  rw [← integral_comp_sub_left (fun x => x ^ k) c]

/-- **Positive part of cone integral**: ∫_0^n (n - t)^(n-1) dt = n^(n-1).

Proof: substitution u = n - t gives ∫_0^n u^(n-1) du = [u^n / n]_0^n = n^n / n = n^(n-1). -/
lemma integral_cone_positive (n : ℕ) (hn : 0 < n) :
    ∫ t in (0 : ℝ)..(n : ℝ), ((n : ℝ) - t) ^ (n - 1) = (n : ℝ) ^ (n - 1 : ℕ) := by
  rw [integral_pow_sub_right (n : ℝ) (n - 1) 0 n]
  simp only [sub_zero, sub_self]
  rw [integral_pow]
  have hn_ne : (n : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hcast : (↑(n - 1) : ℝ) + 1 = (↑n : ℝ) := by exact_mod_cast Nat.succ_pred_eq_of_pos hn
  -- Rewrite exponents: (n-1)+1 = n as ℕ
  conv_lhs =>
    rw [show (n - 1 : ℕ) + 1 = n from Nat.succ_pred_eq_of_pos hn]
  -- Now goal: (n^n - 0^n) / (↑(n-1) + 1) = n^(n-1)
  rw [zero_pow (by omega : n ≠ 0), sub_zero, hcast]
  -- Goal: (n : ℝ)^n / (n : ℝ) = (n : ℝ)^(n-1)
  -- n^n = n^(n-1) * n, so n^n / n = n^(n-1)
  have h_pred : n - 1 + 1 = n := by omega
  have : (n : ℝ) ^ n = (n : ℝ) ^ (n - 1) * (n : ℝ) := by
    rw [← pow_succ, h_pred]
  rw [this, mul_div_cancel_right₀ _ hn_ne]

/-- **Total cone integral**: ∫_{-1}^n (n - t)^(n-1) dt = (n+1)^n / n.

Proof: substitution u = n - t gives ∫_0^{n+1} u^(n-1) du = (n+1)^n / n. -/
lemma integral_cone_total (n : ℕ) (hn : 0 < n) :
    ∫ t in (-1 : ℝ)..(n : ℝ), ((n : ℝ) - t) ^ (n - 1) = ((n : ℝ) + 1) ^ n / (n : ℝ) := by
  rw [integral_pow_sub_right (n : ℝ) (n - 1) (-1) n]
  simp only [sub_neg_eq_add, sub_self]
  rw [integral_pow]
  have hn1_nat : (n - 1 : ℕ) + 1 = n := Nat.succ_pred_eq_of_pos hn
  have hcast : (↑(n - 1) : ℝ) + 1 = (↑n : ℝ) := by exact_mod_cast hn1_nat
  conv_lhs => rw [show (n - 1 : ℕ) + 1 = n from hn1_nat]
  rw [zero_pow (by omega : n ≠ 0), sub_zero, hcast]

/-- **Cone ratio** = (n/(n+1))^n.

The ratio ∫_0^n (n-t)^{n-1} dt / ∫_{-1}^n (n-t)^{n-1} dt equals (n/(n+1))^n. -/
lemma cone_ratio (n : ℕ) (hn : 0 < n) :
    (∫ t in (0 : ℝ)..(n : ℝ), ((n : ℝ) - t) ^ (n - 1)) /
    (∫ t in (-1 : ℝ)..(n : ℝ), ((n : ℝ) - t) ^ (n - 1)) =
    ((n : ℝ) / ((n : ℝ) + 1)) ^ n := by
  rw [integral_cone_positive n hn, integral_cone_total n hn]
  -- LHS = n^(n-1) / ((n+1)^n / n) = n^(n-1) * n / (n+1)^n = n^n / (n+1)^n = (n/(n+1))^n
  rw [div_div_eq_mul_div, div_pow]
  congr 1
  -- n^(n-1) * n = n^n
  have hn1 : n - 1 + 1 = n := Nat.succ_pred_eq_of_pos hn
  rw [← pow_succ, hn1]

/-- **1D Grunbaum inequality** (cone optimality).

For a concave function phi : [a,b] -> R≥0 with phi(a) = 0 and centroid at 0,
the ratio of the integral over [0,b] to the integral over [a,b] (of phi^(n-1))
is at least (n/(n+1))^n.

This is the variational core of Grunbaum's theorem: among all such (n-1)-concave
profiles, the cone profile phi(t) = c*(t-a) achieves the minimum ratio.

**Proof status**: sorry -- requires a variational argument (Prekopa-Leindler or
direct concavity reasoning) not available in Mathlib4. -/
theorem grunbaum_1d_inequality (n : ℕ) (hn : 0 < n)
    (a b : ℝ) (hab : a < 0) (h0b : 0 < b)
    (φ : ℝ → ℝ) (hφ_concave : ConcaveOn ℝ (Set.Icc a b) φ)
    (hφ_nn : ∀ t ∈ Set.Icc a b, 0 ≤ φ t)
    (hφ_a : φ a = 0)
    (h_centroid : ∫ t in a..b, t * φ t ^ (n - 1) = 0) :
    (∫ t in (0 : ℝ)..b, φ t ^ (n - 1)) /
    (∫ t in a..b, φ t ^ (n - 1)) ≥
    ((n : ℝ) / ((n : ℝ) + 1)) ^ n := by
  -- AXIOM: Variational cone optimality (not in Mathlib4).
  -- Classical proof: among concave functions vanishing at a with centroid at 0,
  -- the linear function phi(t) = c*(t - a) minimizes the ratio.
  -- This can be shown using the Prekopa-Leindler inequality or direct
  -- comparison with the cone profile.
  -- Confirmed absent from Mathlib4 after exhaustive search.
  sorry

end
