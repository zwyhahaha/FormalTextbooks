# Lemma 2.2

[Bubeck Convex Optimization](../index.md) / [Chapter 2](../chapters/chapter-2.md) / [Section 2.1](../sections/section-2-1-the-center-of-gravity-method.md)

<div class="chip-row"><a class="chip-link active" href="../../Bubeck_convex_optimization/index.md">Bubeck Convex Optimization</a></div>

**Status:** <span class="status-badge status-partial">Partial</span>

**Roadmap context:** <span class="roadmap-pill roadmap-critical">Critical</span> Stabilize the finite-dimensional geometry chapter by isolating the deepest geometric gaps and sequencing the provable matrix lemmas around them.

## Informal Statement

**Lemma** (\cite{Gru60})

Let $\cK$ be a centered convex set, i.e., $\int_{x \in \cK} x dx = 0$, then for any $w \in \R^n, w \neq 0$, one has

\[
\mathrm{Vol} \left( \cK \cap \{x \in \R^n : x^{\top} w \geq 0\} \right) \geq \frac{1}{e} \mathrm{Vol} (\cK) .
\]

We now prove Theorem \ref{th:centerofgravity}.

## Lean Formalization

Symbol: `lemma_2_2_grunbaum`

```lean
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
  -- AXIOM: Brunn-Minkowski inequality Vol(A+B)^(1/n) ≥ Vol(A)^(1/n) + Vol(B)^(1/n)
  -- This is the core Grünbaum geometric inequality. Classical proof (Grünbaum 1960):
  --   Step A (Fubini slicing): Vol(𝒦) = ∫ v(t) dt, v(t) = Vol_{n-1}(𝒦 ∩ {x₁=t}).
  --   Step B (Brunn-Minkowski): t ↦ v(t)^{1/(n-1)} is concave on its support [a,b].
  --     Requires: 𝒦_{λt+(1-λ)s} ⊇ λ·𝒦_t + (1-λ)·𝒦_s  [from convexity of 𝒦]
  --               + Brunn-Minkowski: Vol(λA+(1-λ)B)^{1/n} ≥ λVol(A)^{1/n}+(1-λ)Vol(B)^{1/n}
  --               NOT IN MATHLIB4. Confirmed absent (2 recursive search levels):
  --               lean_leansearch("Brunn Minkowski volume") → no results
  --               lean_loogle("volume_add") → no results
  --   Step C (Centroid pinning): ∫ t·v(t) dt = 0 forces 0 ∈ (a,b).
  --   Step D (Cone optimality): variational argument shows the minimum ratio (n/(n+1))^n
  --     is achieved by v(t) = (b-t)^{n-1} (cone profile).
  --     NOT IN MATHLIB4. Confirmed absent (2 recursive search levels):
  --               lean_leansearch("extremal concave function integral ratio") → no results
  --               lean_leanfinder("cone volume ratio centroid") → no results
  --   Step E (Combine): ratio ≥ (n/(n+1))^n ≥ exp(-1) = 1/e (Step D + grunbaum_cone_ratio_ge_inv_exp).
  have h_ratio : μ 𝒦 * ENNReal.ofReal
      (((Module.finrank ℝ E : ℝ) / ((Module.finrank ℝ E : ℝ) + 1)) ^ Module.finrank ℝ E) ≤
      μ (𝒦 ∩ {x | (0 : ℝ) ≤ inner (𝕜 := ℝ) x w}) := by
    -- Case split: if 𝒦 has zero measure the LHS is 0 ≤ RHS trivially.
    rcases eq_or_ne (μ 𝒦) 0 with h0 | h0
    · simp [h0]
    · -- Case: μ 𝒦 > 0. Need the full Grünbaum geometric bound.
      --
      -- DEPENDENCY MAP (what has been proved vs. what remains):
      --
      -- [PROVED] 1D Brunn-Minkowski (Lemma22_BM1D.lean, 0 sorries):
      --   brunn_minkowski_one_dim: volume(A) + volume(B) ≤ volume(A + B)
      --   for compact A, B ⊆ ℝ (separated-union trick).
      --
      -- [PROVED] Cone integral computation (Lemma22_ConeOpt.lean, 0 sorries):
      --   cone_ratio: ∫_0^n (n-t)^{n-1} / ∫_{-1}^n (n-t)^{n-1} = (n/(n+1))^n.
      --
      -- [1 SORRY in Lemma22_ConeOpt] grunbaum_1d_inequality:
      --   For concave φ : [a,b] → ℝ≥0 with φ(a)=0 and centroid at 0,
      --   ∫_0^b φ^{n-1} / ∫_a^b φ^{n-1} ≥ (n/(n+1))^n.
      --   (Variational argument; requires Prékopa-Leindler — confirmed Mathlib4 gap.)
      --
      -- REMAINING GAP (this sorry): bridge the n-dimensional setting to grunbaum_1d_inequality.
```

## Metadata

| Field | Value |
|-------|-------|
| Display name | Lemma 2.2 |
| Proof file status | `present` |
| Tracker status | `partial` |
| Computed status | `partial` |
| Proof time | 439m 20s |
| Lean file | [proofs/Bubeck_convex_optimization/Lemma22.lean](https://github.com/zwyhahaha/FormalTextbooks/blob/main/proofs/Bubeck_convex_optimization/Lemma22.lean) |
| Source section | [papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md](https://github.com/zwyhahaha/FormalTextbooks/blob/main/papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md) |

## Dependencies

- Chapter 2 depends on finite-dimensional measure lemmas and matrix identities not needed in Chapter 1.

## Chapter Blockers

- Brunn-Minkowski slicing and cone-optimality arguments are still outside the current Mathlib surface area.
- Several chapter theorems depend on measure-theoretic and matrix-analytic lemmas that are not yet factored into reusable modules.

## Nearby Results

- Previous: [Proposition 1.7](./proposition-1-7.md)
- Next: [Theorem 2.1](./theorem-2-1.md)
