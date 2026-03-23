import Optlib.Convex.Subgradient
import Mathlib.MeasureTheory.Integral.Bochner
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.LinearAlgebra.Dimension.Finrank
import proofs.Bubeck_convex_optimization.Lemma22

set_option linter.unusedSectionVars false
set_option checkBinderAnnotations false

/-!
# Theorem 2.1 — Center of Gravity Method (Bubeck §2.1)

Source: papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md

**Informal statement:** The center of gravity method satisfies
  f(x_t) - min_{x ∈ 𝒳} f(x) ≤ 2B · (1 - 1/e)^{t/n}

**Algorithm** (0-indexed, S_0 = 𝒳, runs for t steps):
1. c_k = centroid of S_k  (= (1/vol(S_k)) ∫_{S_k} x dx)
2. w_k ∈ ∂f(c_k) within 𝒳  (a subgradient of f at c_k)
3. S_{k+1} = S_k ∩ {x : ⟪x − c_k, w_k⟫ ≤ 0}
4. x_t = argmin_{0 ≤ k < t} f(c_k)

**Proof outline:**

**Step 1 — Optimum invariant:** x* ∈ S_k for all k.
  Since w_k ∈ ∂f(c_k) within 𝒳: ∀ y ∈ 𝒳, f(y) ≥ f(c_k) + ⟪w_k, y − c_k⟫.
  Setting y = x* ∈ 𝒳: f(x*) ≥ f(c_k) + ⟪w_k, x* − c_k⟫.
  Since x* is the global minimiser and c_k ∈ 𝒳: f(x*) ≤ f(c_k).
  Therefore ⟪x* − c_k, w_k⟫ ≤ 0, i.e. x* ∈ S_{k+1}.

**Step 2 — Volume decrease:** vol(S_{k+1}) ≤ (1 − 1/e) · vol(S_k).
  Translate S_k by −c_k: the set S_k − c_k has centroid 0 by definition of c_k.
  Apply Lemma 2.2 (Grünbaum, sorry) to (S_k − c_k) with direction w_k:
    vol((S_k−c_k) ∩ {x : ⟪x, w_k⟫ ≥ 0}) ≥ (1/e) vol(S_k−c_k)
  By translation invariance of Haar measure: vol(S_k) is preserved.
  The positive halfspace ⟪x−c_k, w_k⟫ ≥ 0 gets ≥ 1/e of vol(S_k),
  so the negative halfspace ⟪x−c_k, w_k⟫ ≤ 0 (= S_{k+1}) gets ≤ (1−1/e) vol(S_k).

**Step 3 — Volume bound:** vol(S_k) ≤ (1 − 1/e)^k · vol(𝒳) (by induction from Step 2).

**Step 4 — ε-scaling:** For ε > (1−1/e)^{t/n}, define
  𝒳_ε = {(1−ε)·x* + ε·y : y ∈ 𝒳}.
  By linearity of volume: vol(𝒳_ε) = ε^n · vol(𝒳) > (1−1/e)^t · vol(𝒳) ≥ vol(S_t).
  So ∃ k < t, ∃ x_ε ∈ 𝒳_ε with x_ε ∈ S_k but x_ε ∉ S_{k+1}.
  Since x_ε ∉ S_{k+1}: ⟪x_ε − c_k, w_k⟫ > 0.
  By subgradient at c_k: f(x_ε) ≥ f(c_k) + ⟪w_k, x_ε − c_k⟫ > f(c_k).
  By convexity of f and x_ε = (1−ε)x* + εy with y ∈ 𝒳:
    f(x_ε) ≤ (1−ε)f(x*) + ε·f(y) ≤ f(x*) + ε·2B.
  Therefore f(c_k) < f(x_ε) ≤ f(x*) + 2εB.
  Taking ε → (1−1/e)^{t/n}: f(x_t) = min_{k<t} f(c_k) ≤ f(x*) + 2B·(1−1/e)^{t/n}.

**Sorry obligations:**
  (A) `cog_volume_decrease` — depends on Lemma 2.2 (which is itself sorry).
  (B) The main theorem relies on (A) plus the ε-scaling measure argument.
-/

open MeasureTheory Real InnerProductSpace Set

local notation "⟪" x ", " y "⟫" => @inner ℝ _ _ x y

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    [FiniteDimensional ℝ E] [CompleteSpace E]
    [MeasurableSpace E] [BorelSpace E]

/-!
## Key Lemma: One-Step Volume Decrease

The halfspace cut S_{k+1} = S_k ∩ {x : ⟪x − c, w⟫ ≤ 0} satisfies
  vol(S_{k+1}) ≤ (1 − 1/e) · vol(S_k)
whenever c is the centroid of S_k. This is a direct corollary of Lemma 2.2.
-/

/-- **Volume decrease** (corollary of Lemma 2.2, Bubeck §2.1 proof).

For a convex measurable set S with finite Haar measure μ and centroid c
(i.e., `∫ x in S, x ∂μ = (μ S).toReal • c`), the halfspace cut
  S ∩ {x : ⟪x − c, w⟫ ≤ 0}
has measure at most `(1 − 1/e) · μ S`.

**Proof:** Translate by −c to get S' := S − c with centroid 0.
Lemma 2.2 gives μ(S' ∩ {x : ⟪x,w⟫ ≥ 0}) ≥ μ(S')/e = μ(S)/e.
By complement: μ(S ∩ {x : ⟪x−c,w⟫ ≤ 0}) ≤ (1 − 1/e) · μ(S). -/
theorem cog_volume_decrease
    (μ : Measure E) [Measure.IsAddHaarMeasure μ]
    {S : Set E}
    (hS_convex  : Convex ℝ S)
    (hS_meas    : MeasurableSet S)
    (hS_finite  : μ S < ⊤)
    (hS_nonempty : (μ S).toReal > 0)
    {c : E} (hc : ∫ x in S, x ∂μ = (μ S).toReal • c)
    {w : E} (hw : w ≠ 0) :
    μ (S ∩ {x | ⟪x - c, w⟫ ≤ 0}) ≤
      ENNReal.ofReal (1 - 1 / exp 1) * μ S := by
  -- Let S' = (· - c) '' S = S − c. Then:
  --   (1) μ S' = μ S  (translation invariance of Haar measure)
  --   (2) ∫ x in S', x ∂μ = 0  (centroid of S' is 0, from hc)
  --   (3) Apply lemma_2_2_grunbaum to S' with direction w:
  --       μ(S' ∩ {x : ⟪x,w⟫ ≥ 0}) ≥ μ S' / e
  --   (4) S' ∩ {x : ⟪x,w⟫ ≥ 0} corresponds to S ∩ {x : ⟪x−c,w⟫ ≥ 0}
  --       under the translation x ↦ x − c
  --   (5) μ S = μ(S ∩ {x : ⟪x−c,w⟫ ≥ 0}) + μ(S ∩ {x : ⟪x−c,w⟫ ≤ 0})
  --       (the hyperplane {x : ⟪x−c,w⟫ = 0} has measure 0)
  --   (6) From (3)(4)(5): μ(S ∩ {⟪x−c,w⟫ ≤ 0}) ≤ (1−1/e) μ S
  sorry

/-!
## Main Theorem: Convergence of the Center of Gravity Method
-/

/-- **Theorem 2.1** (Bubeck §2.1): Convergence of the center of gravity method.

Given a convex body 𝒳 ⊆ E, a convex function f : E → ℝ bounded by B, and
sequences S_k, c_k, w_k encoding t steps of the algorithm:
  f(x_t) - min_{x ∈ 𝒳} f(x) ≤ 2 * B * (1 − 1/e)^(t/n)

where n = finrank ℝ E and x_t = argmin_{k < t} f(c_k).

**Dependencies:** Uses `cog_volume_decrease` (and hence Lemma 2.2, sorry). -/
theorem theorem_2_1_center_of_gravity
    (μ : Measure E) [Measure.IsAddHaarMeasure μ]
    -- Convex body 𝒳 ⊆ E
    {𝒳 : Set E}
    (h𝒳_compact   : IsCompact 𝒳)
    (h𝒳_convex    : Convex ℝ 𝒳)
    (h𝒳_interior  : (interior 𝒳).Nonempty)
    -- Convex function f : E → ℝ with |f| ≤ B on 𝒳
    {f : E → ℝ} {B : ℝ} (hB : 0 < B)
    (hf_convex    : ConvexOn ℝ 𝒳 f)
    (hf_bounded   : ∀ x ∈ 𝒳, |f x| ≤ B)
    -- Algorithm sequences (0-indexed, length t)
    (S : ℕ → Set E)  -- constraint sets
    (c : ℕ → E)      -- centroids
    (w : ℕ → E)      -- subgradients
    -- Algorithm invariants
    (hS_init     : S 0 = 𝒳)
    (hS_convex   : ∀ k, Convex ℝ (S k))
    (hS_meas     : ∀ k, MeasurableSet (S k))
    (hS_finite   : ∀ k, μ (S k) < ⊤)
    (hS_pos      : ∀ k, (μ (S k)).toReal > 0)
    (hS_sub      : ∀ k, S k ⊆ 𝒳)
    -- c_k is the centroid of S_k: ∫_{S_k} x dμ = vol(S_k) · c_k
    (hc_centroid : ∀ k, ∫ x in S k, x ∂μ = (μ (S k)).toReal • c k)
    -- c_k ∈ 𝒳 (centroid of a subset of 𝒳 lies in 𝒳 by convexity)
    (hc_mem      : ∀ k, c k ∈ 𝒳)
    -- w_k is a subgradient of f at c_k within 𝒳
    (hw_sub      : ∀ k, HasSubgradientWithinAt f (w k) 𝒳 (c k))
    -- w_k ≠ 0 (non-degenerate; if w_k = 0 then c_k is already optimal)
    (hw_ne       : ∀ k, w k ≠ 0)
    -- Algorithm step: S_{k+1} = S_k ∩ {x : ⟪x − c_k, w_k⟫ ≤ 0}
    (hS_step     : ∀ k, S (k + 1) = S k ∩ {x | ⟪x - c k, w k⟫ ≤ 0})
    -- Number of steps
    (t : ℕ) :
    (⨅ k ∈ Finset.range t, f (c k)) - ⨅ x ∈ 𝒳, f x ≤
      2 * B * (1 - 1 / exp 1) ^ ((t : ℝ) / (Module.finrank ℝ E : ℝ)) := by
  -- PROOF (all steps are sorry, see proof outline in module doc):
  --
  -- Step 1 — Optimum invariant (proved by induction):
  --   Let xstar := argmin_{𝒳} f.  Claim: xstar ∈ S k for all k.
  --   Base: xstar ∈ 𝒳 = S 0.
  --   Inductive step: assume xstar ∈ S k.
  --     By hw_sub k:  ∀ y ∈ 𝒳, f (c k) + ⟪w k, y − c k⟫ ≤ f y.
  --     Set y = xstar: f (c k) + ⟪w k, xstar − c k⟫ ≤ f xstar.
  --     Since c k ∈ 𝒳 and xstar is optimal: f xstar ≤ f (c k).
  --     Therefore ⟪w k, xstar − c k⟫ ≤ 0, i.e. ⟪xstar − c k, w k⟫ ≤ 0.
  --     So xstar ∈ {x : ⟪x − c k, w k⟫ ≤ 0} ∩ S k = S (k+1).
  --
  -- Step 2 — Volume decrease (by cog_volume_decrease):
  --   μ (S (k+1)) ≤ (1 − 1/e) * μ (S k)   for all k.
  --   (Requires hw_ne k for the w ≠ 0 condition of Lemma 2.2.)
  --
  -- Step 3 — Cumulative volume bound (by induction from Step 2):
  --   μ (S t) ≤ ENNReal.ofReal ((1 − 1/e)^t) * μ 𝒳.
  --
  -- Step 4 — ε-scaling argument:
  --   Let n := Module.finrank ℝ E.
  --   The set 𝒳_ε := (1−ε) • xstar + ε • 𝒳 is a scaled copy of 𝒳.
  --   By the n-homogeneity of Haar measure: μ 𝒳_ε = ε^n * μ 𝒳.
  --   For ε := (1−1/e)^(t/n), we get μ 𝒳_ε = (1−1/e)^t * μ 𝒳 ≥ μ (S t).
  --   So 𝒳_ε ⊄ S_t: there exists k < t and x_ε ∈ 𝒳_ε with
  --     x_ε ∈ S k but x_ε ∉ S (k+1).
  --   Since x_ε ∉ S (k+1) = S k ∩ {⟪x−c k, w k⟫ ≤ 0}:
  --     ⟪x_ε − c k, w k⟫ > 0.
  --   By subgradient (hw_sub k) at y = x_ε:
  --     f x_ε ≥ f (c k) + ⟪w k, x_ε − c k⟫ > f (c k).
  --   By convexity of f and x_ε = (1−ε)·xstar + ε·y for some y ∈ 𝒳:
  --     f x_ε ≤ (1−ε) * f xstar + ε * f y ≤ f xstar + ε * 2 * B.
  --   Therefore f (c k) < f xstar + 2 * B * ε.
  --   Since x_t = argmin_{k<t} f(c_k), we get f(x_t) ≤ f(c_k) < f xstar + 2Bε.
  --
  -- Step 5 — Conclude:
  --   f(x_t) − f(xstar) < 2 * B * (1−1/e)^(t/n).
  sorry
