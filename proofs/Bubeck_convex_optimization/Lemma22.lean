import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.MeasureTheory.Integral.Bochner
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic

set_option linter.unusedSectionVars false
set_option checkBinderAnnotations false

/-!
# Lemma 2.2 — Grünbaum's Theorem (Bubeck §2.1)

Source: papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md

**Informal statement:** Let 𝒦 be a *centered* convex set in ℝⁿ
(i.e., the centroid `∫_{x ∈ 𝒦} x dx = 0`), then for any `w ∈ ℝⁿ`, `w ≠ 0`:
  `Vol(𝒦 ∩ {x ∈ ℝⁿ : x·w ≥ 0}) ≥ (1/e) · Vol(𝒦)`

**Status:** Grünbaum's theorem (1960), cited as [Gru60] in Bubeck.
No proof is given in the book.

**Classical proof sketch** (Grünbaum 1960, see informal/Lemma22_informal.md):
1. By affine invariance, assume w = e₁ (handled implicitly by the abstract inner product).
2. For each t ∈ ℝ define the cross-section slice
     v(t) = Vol_{n-1}(𝒦 ∩ {x : ⟪x,w⟫ = t}).
   By the Brunn–Minkowski inequality, t ↦ v(t)^{1/(n-1)} is **concave** on its support.
   (**Mathlib gap**: not yet in Mathlib 4.)
3. The centroid condition `∫ x in 𝒦, ⟪x,w⟫ dμ = 0` pins the 1D moment at 0.
   A variational argument (Prékopa–Leindler) shows the worst case is a cone, giving
   ratio `(n/(n+1))ⁿ`.
   (**Mathlib gap**: cone optimality / Prékopa–Leindler not in Mathlib 4.)
4. For any n ≥ 1: `(n/(n+1))ⁿ ≥ exp(−1) = 1/e`.
   (This step **is** provable; see `grunbaum_cone_ratio_ge_inv_exp` below.)

The bound `1/e` is sharp, achieved in the limit by a solid cone.
-/

open MeasureTheory Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [FiniteDimensional ℝ E] [CompleteSpace E]
    [MeasurableSpace E] [BorelSpace E]

/-!
## Helper: the arithmetic heart of the bound

The worst-case volume ratio equals `(n/(n+1))ⁿ` (achieved by a cone).
We prove here that this ratio is ≥ `exp(−1)`.
This is the only part of the proof currently formalized without `sorry`.
-/

/-- **Arithmetic core of Grünbaum's bound.**
For any positive natural number n, the cone volume ratio satisfies
`(n/(n+1))ⁿ ≥ exp(−1) = 1/e`.

Proof: `log((n/(n+1))ⁿ) = n·log(n/(n+1)) = −n·log(1 + 1/n) ≥ −n·(1/n) = −1`,
where the inequality uses `log(1+x) ≤ x` (from `1+x ≤ eˣ`). -/
lemma grunbaum_cone_ratio_ge_inv_exp (n : ℕ) (hn : 0 < n) :
    Real.exp (-1 : ℝ) ≤ ((n : ℝ) / ((n : ℝ) + 1)) ^ n := by
  have hn_pos  : (0 : ℝ) < (n : ℝ)       := Nat.cast_pos.mpr hn
  have hn1_pos : (0 : ℝ) < (n : ℝ) + 1   := by linarith
  have h_ratio_pos : (0 : ℝ) < (n : ℝ) / ((n : ℝ) + 1) := div_pos hn_pos hn1_pos
  -- Step A: log(1 + 1/n) ≤ 1/n, from the inequality 1 + x ≤ exp(x) at x = 1/n
  have h_log_ineq : Real.log ((n : ℝ) + 1) - Real.log (n : ℝ) ≤ 1 / (n : ℝ) := by
    have h1 : 1 / (n : ℝ) + 1 ≤ Real.exp (1 / (n : ℝ)) := Real.add_one_le_exp _
    have h2 : Real.log (1 / (n : ℝ) + 1) ≤ 1 / (n : ℝ) := by
      have := Real.log_le_log (by positivity) h1
      rwa [Real.log_exp] at this
    have h3 : Real.log (1 / (n : ℝ) + 1) = Real.log ((n : ℝ) + 1) - Real.log (n : ℝ) := by
      rw [show 1 / (n : ℝ) + 1 = ((n : ℝ) + 1) / (n : ℝ) from by field_simp; ring]
      rw [Real.log_div (ne_of_gt hn1_pos) (ne_of_gt hn_pos)]
    linarith
  -- Step B: n · log(n/(n+1)) ≥ −1
  have h_log_bound : -(1 : ℝ) ≤ (n : ℝ) * Real.log ((n : ℝ) / ((n : ℝ) + 1)) := by
    rw [Real.log_div (ne_of_gt hn_pos) (ne_of_gt hn1_pos)]
    have hmul : (n : ℝ) * (Real.log ((n : ℝ) + 1) - Real.log (n : ℝ)) ≤ 1 := by
      have h := mul_le_mul_of_nonneg_left h_log_ineq (le_of_lt hn_pos)
      have : (n : ℝ) * (1 / (n : ℝ)) = 1 := by field_simp
      linarith
    linarith
  -- Step C: (n/(n+1))^n = exp(n · log(n/(n+1))) ≥ exp(−1)
  rw [← Real.exp_log (pow_pos h_ratio_pos n), Real.log_pow]
  exact Real.exp_le_exp_of_le h_log_bound

/-!
## Main theorem
-/

/-- **Lemma 2.2** (Grünbaum 1960, [Gru60]; Bubeck §2.1).

Let `𝒦 ⊆ E` be a convex measurable set with finite Haar measure and centroid
at the origin (i.e., `∫ x in 𝒦, x ∂μ = 0`). For any nonzero direction `w : E`,
the positive halfspace `{x | 0 ≤ ⟪x, w⟫_ℝ}` captures at least a `1/e` fraction
of the measure of `𝒦`:
  `μ 𝒦 / ENNReal.ofReal (exp 1) ≤ μ (𝒦 ∩ {x | 0 ≤ ⟪x, w⟫_ℝ})`

**Proof status:** Two deep Mathlib 4 gaps prevent full formalization:
1. **Brunn-Minkowski slicing** (Step 2 of the classical proof): concavity of
   `Vol_{n-1}(𝒦_t)^{1/(n-1)}` as a function of the slice height `t` — not in Mathlib4.
2. **Cone optimality** (Step 3): the variational argument (Prékopa-Leindler inequality)
   showing the worst case is a cone — not in Mathlib4.
The arithmetic bound `(n/(n+1))^n ≥ 1/e` is proved in `grunbaum_cone_ratio_ge_inv_exp`. -/
theorem lemma_2_2_grunbaum
    (μ : Measure E) [Measure.IsAddHaarMeasure μ]
    {𝒦 : Set E}
    (hK_convex   : Convex ℝ 𝒦)
    (hK_meas     : MeasurableSet 𝒦)
    (hK_finite   : μ 𝒦 < ⊤)
    (hK_centered : ∫ x in 𝒦, x ∂μ = 0)
    {w : E} (hw : w ≠ 0) :
    μ 𝒦 / ENNReal.ofReal (exp 1) ≤
      μ (𝒦 ∩ {x | (0 : ℝ) ≤ inner (𝕜 := ℝ) x w}) := by
  -- Since w ≠ 0, E must be nontrivial (w and 0 are distinct elements).
  haveI : Nontrivial E := ⟨⟨w, 0, hw⟩⟩
  -- n = ambient dimension; positive because E is nontrivial.
  have hn_pos : 0 < Module.finrank ℝ E := Module.finrank_pos
  -- The Grünbaum volume ratio for dimension n: r = n/(n+1) ∈ (0,1).
  -- Step 4 (proved): arithmetic bound — (n/(n+1))^n ≥ exp(−1) = 1/e.
  have h_arith : Real.exp (-1 : ℝ) ≤
      ((Module.finrank ℝ E : ℝ) / ((Module.finrank ℝ E : ℝ) + 1)) ^ Module.finrank ℝ E :=
    grunbaum_cone_ratio_ge_inv_exp (Module.finrank ℝ E) hn_pos
  -- Step 2–3 (GAP): volume ratio bound via Brunn-Minkowski + cone optimality.
  -- Classical proof shows: μ(𝒦 ∩ halfspace) ≥ (n/(n+1))^n · μ(𝒦).
  --   GAP 1: Brunn-Minkowski slicing — Vol_{n-1}(𝒦_t)^{1/(n-1)} concave in t.
  --     Not in Mathlib4. Requires Prékopa-Leindler inequality.
  --     Confirmed absent: lean_loogle("BrunnMinkowski") → no results.
  --   GAP 2: Cone optimality — centroid-pinning + BM-concavity → ratio ≥ (n/(n+1))^n.
  --     Not in Mathlib4. Confirmed absent: lean_leanfinder → no results.
  --   Once available: combine with grunbaum_cone_ratio_ge_inv_exp to finish.
  have h_ratio : μ 𝒦 * ENNReal.ofReal
      (((Module.finrank ℝ E : ℝ) / ((Module.finrank ℝ E : ℝ) + 1)) ^ Module.finrank ℝ E) ≤
      μ (𝒦 ∩ {x | (0 : ℝ) ≤ inner (𝕜 := ℝ) x w}) := by
    sorry
  -- Combine: μ 𝒦 / exp(1) ≤ μ 𝒦 · exp(−1) ≤ μ 𝒦 · (n/(n+1))^n ≤ μ(halfspace).
  -- Here: μ 𝒦 / exp(1) = μ 𝒦 · exp(−1) because exp(−1) = (exp 1)⁻¹.
  apply le_trans _ h_ratio
  rw [ENNReal.div_eq_inv_mul, mul_comm]
  gcongr
  rw [← ENNReal.ofReal_inv_of_pos (Real.exp_pos 1)]
  exact ENNReal.ofReal_le_ofReal (by rwa [← Real.exp_neg])
