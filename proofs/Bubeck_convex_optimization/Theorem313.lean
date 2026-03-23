import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Strong
import Mathlib.LinearAlgebra.Span
import Optlib.Convex.StronglyConvex
import Optlib.Convex.Subgradient

set_option linter.unusedSectionVars false
set_option linter.unusedVariables false

open EuclideanSpace InnerProductSpace Set Finset

/-!
# Theorem 3.13 — Oracle Complexity Lower Bounds (Bubeck §3.5)

Source: papers/Bubeck_convex_optimization/sections/03_05_lower_bounds.md

## Strongly convex lower bound

Let t ≤ n, L, α > 0. There exists an α-strongly convex and L-Lipschitz function
f : ℝⁿ → ℝ such that for any black-box procedure satisfying the span condition
  x₁ = 0,  x_{s+1} ∈ Span(g₁, …, gₛ),  gₛ ∈ ∂f(xₛ),
we have for all 1 ≤ s ≤ t:
  f(xₛ) − f* ≥ L² / (8 α t).

## Proof sketch

Hard instance: f(x) = (L/2)·max_{1≤i≤t} xᵢ + (α/2)‖x‖².

1. f is α-strongly convex (quadratic term).
2. ‖g‖ ≤ αR + L/2 = L for g ∈ ∂f(x), ‖x‖ ≤ R = L/(2α).
3. Span induction: gₛ ∈ ∂f(xₛ) with xₛ ∈ Span(e₁,…,eₛ₋₁)
   implies gₛ ∈ Span(e₁,…,eₛ), so xₛ₊₁ ∈ Span(e₁,…,eₛ).
4. f(xₛ) ≥ 0 since the max coordinate is 0 (xₛ(t) = 0 for s ≤ t).
5. Minimizer y*(i) = −L/(4αt) for i<t gives f(y*) = −L²/(8αt).
6. Gap ≥ L²/(8αt). □
-/

noncomputable section

variable {n : ℕ}

/-! ### The hard function and its minimizer -/

/-- Hard instance: f(x) = γ·max_{i<t} x(i) + (α/2)‖x‖². -/
def hardFun (α γ : ℝ) {t : ℕ} (htpos : 0 < t) (htlen : t ≤ n)
    (x : EuclideanSpace ℝ (Fin n)) : ℝ :=
  γ * Finset.sup' Finset.univ ⟨⟨0, htpos⟩, Finset.mem_univ _⟩
        (fun i : Fin t => x (Fin.castLE htlen i)) +
  α / 2 * ‖x‖ ^ 2

/-- Explicit minimizer: y*(i) = −γ/(αt) for i < t, else 0. -/
def hardMin (α γ : ℝ) (t : ℕ) (htlen : t ≤ n) : EuclideanSpace ℝ (Fin n) :=
  (WithLp.equiv 2 (Fin n → ℝ)).symm (fun i => if i.val < t then -(γ / (α * t)) else 0)

/-- Coordinate access for hardMin. -/
lemma hardMin_apply (α γ : ℝ) (t : ℕ) (htlen : t ≤ n) (i : Fin n) :
    hardMin α γ t htlen i = if i.val < t then -(γ / (α * t)) else 0 := by
  simp [hardMin, WithLp.equiv_symm_pi_apply]

/-! ### Properties: strongly convex, Lipschitz, minimizer value -/

/-- hardFun is α-strongly convex, assuming γ ≥ 0. -/
lemma hardFun_stronglyConvex (α γ : ℝ) (hα : 0 < α) (hγ : 0 ≤ γ) {t : ℕ} (htpos : 0 < t)
    (htlen : t ≤ n) :
    StrongConvexOn (Set.univ : Set (EuclideanSpace ℝ (Fin n))) α
      (hardFun α γ htpos htlen) := by
  rw [strongConvexOn_iff_convex]
  set hH : (Finset.univ : Finset (Fin t)).Nonempty := ⟨⟨0, htpos⟩, Finset.mem_univ _⟩
  -- hardFun(x) - α/2*‖x‖² = γ • sup_{i<t} x(i)
  have heq : (fun x : EuclideanSpace ℝ (Fin n) =>
      hardFun α γ htpos htlen x - α / 2 * ‖x‖ ^ 2) =
      (fun x => γ • Finset.univ.sup' hH (fun i : Fin t => x (Fin.castLE htlen i))) := by
    ext x; unfold hardFun; simp only [smul_eq_mul]; ring
  rw [heq]
  -- γ ≥ 0 and max is convex → γ•max is convex
  apply ConvexOn.smul hγ
  -- Rewrite: (fun x => sup' hH (fun i => x eᵢ)) = sup' hH (fun i x => x eᵢ)
  rw [show (fun x : EuclideanSpace ℝ (Fin n) =>
      Finset.univ.sup' hH (fun i : Fin t => x (Fin.castLE htlen i))) =
      Finset.univ.sup' hH (fun i : Fin t => fun x : EuclideanSpace ℝ (Fin n) =>
        x (Fin.castLE htlen i)) from
      funext fun x => (Finset.sup'_apply hH (fun i y => y (Fin.castLE htlen i)) x).symm]
  -- max of linear functions is convex
  exact Finset.sup'_induction hH
      (fun i : Fin t => fun x : EuclideanSpace ℝ (Fin n) => x (Fin.castLE htlen i))
      (fun f hf g hg => hf.sup hg)
      (fun i _ => (EuclideanSpace.projₗ (𝕜 := ℝ) (Fin.castLE htlen i)).convexOn convex_univ)

/-- Subgradient norm bound: ‖g‖ ≤ L for g ∈ ∂f(x), ‖x‖ ≤ L/(2α). -/
lemma hardFun_subgradient_bound (α γ L : ℝ) (hα : 0 < α) (hγ : γ = L / 2)
    (hL : 0 < L) {t : ℕ} (htpos : 0 < t) (htlen : t ≤ n)
    (x : EuclideanSpace ℝ (Fin n)) (hx : ‖x‖ ≤ L / (2 * α))
    (g : EuclideanSpace ℝ (Fin n)) (hg : g ∈ SubderivAt (hardFun α γ htpos htlen) x) :
    ‖g‖ ≤ L := by
  sorry

/-- f(y*) = −γ²/(2αt). -/
lemma hardFun_min_value (α γ : ℝ) (hα : 0 < α) {t : ℕ} (htpos : 0 < t)
    (htlen : t ≤ n) :
    hardFun α γ htpos htlen (hardMin α γ t htlen) = -(γ ^ 2 / (2 * α * t)) := by
  unfold hardFun
  have ht_pos : (0 : ℝ) < t := Nat.cast_pos.mpr htpos
  -- Step 1: compute sup' = −γ/(α*t), since every coordinate equals this
  have hsup : ∀ (H : (Finset.univ : Finset (Fin t)).Nonempty),
      Finset.sup' Finset.univ H
        (fun i : Fin t => hardMin α γ t htlen (Fin.castLE htlen i)) = -(γ / (α * t)) :=
    fun H => Finset.sup'_eq_of_forall H _ (fun i _ => by
      simp only [hardMin_apply, Fin.coe_castLE]
      exact if_pos i.isLt)
  -- Step 2: compute ‖hardMin‖² = t * (γ/(α*t))²
  have hnorm_sq : ‖hardMin α γ t htlen‖ ^ 2 = t * (γ / (α * t)) ^ 2 := by
    have h1 : ‖hardMin α γ t htlen‖ ^ 2 = ∑ i : Fin n, (hardMin α γ t htlen i) ^ 2 := by
      rw [PiLp.norm_sq_eq_of_L2]; simp only [Real.norm_eq_abs, sq_abs]
    rw [h1]
    simp_rw [hardMin_apply]
    trans (∑ i : Fin n, if i.val < t then (γ / (α * ↑t)) ^ 2 else 0)
    · congr 1; ext i; split_ifs <;> simp [neg_sq]
    · rw [Finset.sum_ite, Finset.sum_const_zero, add_zero, Finset.sum_const, nsmul_eq_mul]
      congr 1
      have hfilt : (Finset.univ : Finset (Fin n)).filter (fun i => i.val < t) =
          (Finset.univ : Finset (Fin t)).image (Fin.castLE htlen) := by
        ext i
        simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_image]
        exact ⟨fun h => ⟨⟨i.val, h⟩, by ext; simp [Fin.castLE]⟩,
               fun ⟨j, heq⟩ => by rw [← heq]; simp [Fin.coe_castLE, j.isLt]⟩
      rw [hfilt, Finset.card_image_of_injective _ (Fin.castLE_injective htlen)]
      simp [Fintype.card_fin]
  -- Step 3: combine and simplify
  have goal_eq : γ * Finset.univ.sup' ⟨⟨0, htpos⟩, Finset.mem_univ _⟩
      (fun i : Fin t => hardMin α γ t htlen (Fin.castLE htlen i)) +
      α / 2 * ‖hardMin α γ t htlen‖ ^ 2 = -(γ ^ 2 / (2 * α * t)) := by
    rw [hsup, hnorm_sq]
    field_simp; ring
  exact goal_eq

/-- y* is the global minimizer (requires γ ≥ 0). -/
lemma hardMin_isMinimizer (α γ : ℝ) (hα : 0 < α) (hγ : 0 ≤ γ) {t : ℕ} (htpos : 0 < t)
    (htlen : t ≤ n) (y : EuclideanSpace ℝ (Fin n)) :
    hardFun α γ htpos htlen (hardMin α γ t htlen) ≤ hardFun α γ htpos htlen y := by
  rw [hardFun_min_value α γ hα htpos htlen]; unfold hardFun
  have ht_pos : (0 : ℝ) < (t : ℝ) := Nat.cast_pos.mpr htpos
  have ht_ne : (t : ℝ) ≠ 0 := ne_of_gt ht_pos
  have hα_ne : α ≠ 0 := ne_of_gt hα
  set hH : (Finset.univ : Finset (Fin t)).Nonempty := ⟨⟨0, htpos⟩, Finset.mem_univ _⟩
  set xi : Fin t → ℝ := fun i => y (Fin.castLE htlen i)
  set M := Finset.univ.sup' hH xi
  set S := ∑ i : Fin t, xi i
  set Q := ∑ i : Fin t, xi i ^ 2
  -- max ≥ average: t * M ≥ S
  have hMge : ↑t * M ≥ S := calc
    S ≤ ∑ _i : Fin t, M := Finset.sum_le_sum (fun i _ => Finset.le_sup' xi (Finset.mem_univ _))
    _ = ↑t * M := by rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  -- Cauchy-Schwarz: S² ≤ t * Q  (using (Σ 1·xi)² ≤ (Σ 1²)·(Σ xi²))
  have hCS : S ^ 2 ≤ ↑t * Q := by
    have h := Finset.sum_mul_sq_le_sq_mul_sq Finset.univ (fun _ : Fin t => (1:ℝ)) xi
    simp only [one_mul, one_pow, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
               nsmul_eq_mul, mul_one, S, Q] at h
    exact_mod_cast h
  -- ‖y‖² ≥ Q
  have hNge : ‖y‖ ^ 2 ≥ Q := by
    rw [show ‖y‖ ^ 2 = ∑ i : Fin n, (y i) ^ 2 from by
      rw [PiLp.norm_sq_eq_of_L2]; simp [Real.norm_eq_abs, sq_abs]]
    calc Q = ∑ i in Finset.univ.image (Fin.castLE htlen), (y i) ^ 2 := by
          rw [Finset.sum_image (fun i _ j _ h => Fin.castLE_injective htlen h)]
      _ ≤ ∑ i : Fin n, (y i) ^ 2 :=
          Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _) (fun _ _ _ => sq_nonneg _)
  -- Key: (1/t) * α/2 * (S + γ/α)² ≥ 0, and this equals γ/t*S + α/(2t)*S² + γ²/(2αt)
  have h3 : γ / ↑t * S + α / (2 * ↑t) * S ^ 2 + γ ^ 2 / (2 * α * ↑t) ≥ 0 := by
    have heq : γ / ↑t * S + α / (2 * ↑t) * S ^ 2 + γ ^ 2 / (2 * α * ↑t) =
        1 / ↑t * (α / 2 * (S + γ / α) ^ 2) := by field_simp; ring
    rw [heq]; positivity
  -- γ * M ≥ γ/t * S (from hMge and hγ)
  have h1 : γ / ↑t * S ≤ γ * M := by
    rw [div_mul_eq_mul_div, div_le_iff ht_pos]
    nlinarith [mul_le_mul_of_nonneg_left hMge hγ]
  -- α/2 * ‖y‖² ≥ α/(2t) * S² (from hNge, hCS, α > 0)
  have h2 : α / (2 * ↑t) * S ^ 2 ≤ α / 2 * ‖y‖ ^ 2 := by
    have step1 : S ^ 2 ≤ ↑t * ‖y‖ ^ 2 := by nlinarith
    rw [← sub_nonneg,
        show α / 2 * ‖y‖ ^ 2 - α / (2 * ↑t) * S ^ 2 =
            α / (2 * ↑t) * (↑t * ‖y‖ ^ 2 - S ^ 2) from by field_simp; ring]
    apply mul_nonneg (by positivity); linarith
  -- Combine: γ*M + α/2*‖y‖² + γ²/(2αt) ≥ γ/t*S + α/(2t)*S² + γ²/(2αt) ≥ 0
  linarith [h3, h1, h2]

/-! ### Span structure and induction -/

/-- e_i : standard basis vector at index i in EuclideanSpace ℝ (Fin n). -/
abbrev eVec (i : Fin n) : EuclideanSpace ℝ (Fin n) := EuclideanSpace.single i 1

/-- The span of the first k basis vectors. -/
def spanFirstK (k : ℕ) (hkn : k ≤ n) : Submodule ℝ (EuclideanSpace ℝ (Fin n)) :=
  Submodule.span ℝ (Set.range (fun i : Fin k => eVec (Fin.castLE hkn i)))

/-- x ∈ spanFirstK k iff coordinates ≥ k vanish. -/
lemma mem_spanFirstK (k : ℕ) (hkn : k ≤ n) (x : EuclideanSpace ℝ (Fin n)) :
    x ∈ spanFirstK k hkn ↔ ∀ j : Fin n, k ≤ j.val → x j = 0 := by
  unfold spanFirstK eVec
  constructor
  · intro hmem j hj
    apply Submodule.span_induction (p := fun v _ => v j = 0) (hx := hmem)
    · rintro v ⟨i, rfl⟩
      simp only [EuclideanSpace.single_apply]
      have hne : j ≠ Fin.castLE hkn i := fun h => by
        have := congr_arg Fin.val h; simp [Fin.coe_castLE] at this; omega
      simp [hne]
    · simp
    · intro u v _ _ hu hv; simp [hu, hv]
    · intro a u _ hu; simp [hu]
  · intro hzero
    have hx_eq : x = ∑ i : Fin k,
        x (Fin.castLE hkn i) • EuclideanSpace.single (Fin.castLE hkn i) 1 := by
      funext j
      have hdist : (∑ i : Fin k,
            x (Fin.castLE hkn i) • EuclideanSpace.single (Fin.castLE hkn i) (1:ℝ)) j =
          ∑ i : Fin k,
            (x (Fin.castLE hkn i) • EuclideanSpace.single (Fin.castLE hkn i) (1:ℝ)) j := by
        show (EuclideanSpace.projₗ (𝕜 := ℝ) j)
            (∑ i : Fin k,
              x (Fin.castLE hkn i) • EuclideanSpace.single (Fin.castLE hkn i) (1:ℝ)) =
          ∑ i : Fin k,
            (EuclideanSpace.projₗ (𝕜 := ℝ) j)
              (x (Fin.castLE hkn i) • EuclideanSpace.single (Fin.castLE hkn i) (1:ℝ))
        apply map_sum
      have hterm : ∀ i : Fin k,
          (x (Fin.castLE hkn i) • EuclideanSpace.single (Fin.castLE hkn i) (1:ℝ)) j =
          x (Fin.castLE hkn i) * if j = Fin.castLE hkn i then 1 else 0 := fun i => by
        simp [EuclideanSpace.single_apply, smul_eq_mul]
      rw [hdist]; simp_rw [hterm]
      by_cases hjk : j.val < k
      · rw [Finset.sum_eq_single ⟨j.val, hjk⟩]
        · simp [Fin.ext_iff, Fin.coe_castLE]
        · intro b _ hb
          have hne : j ≠ Fin.castLE hkn b := fun h => hb (Fin.ext (by
            have := congr_arg Fin.val h; simp [Fin.coe_castLE] at this; exact this.symm))
          simp [hne]
        · intro h; exact absurd (Finset.mem_univ _) h
      · push_neg at hjk
        rw [hzero j hjk]
        symm; apply Finset.sum_eq_zero; intro i _
        have hne : j ≠ Fin.castLE hkn i := fun h => by
          have := congr_arg Fin.val h; simp [Fin.coe_castLE] at this; omega
        simp [hne]
    rw [hx_eq]
    apply Submodule.sum_mem; intro i _
    exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨i, rfl⟩)

/-- Span induction step: subgradients of hardFun at x ∈ spanFirstK s
    lie in spanFirstK (s+1). -/
lemma subgradient_in_span (α γ : ℝ) (hα : 0 < α) (hγ : 0 < γ)
    {t : ℕ} (htpos : 0 < t) (htlen : t ≤ n)
    (s : ℕ) (hs : s < t) (hs1n : s + 1 ≤ n)
    (x : EuclideanSpace ℝ (Fin n)) (hx : x ∈ spanFirstK s (Nat.le_of_lt (Nat.lt_of_lt_of_le hs htlen)))
    (g : EuclideanSpace ℝ (Fin n)) (hg : g ∈ SubderivAt (hardFun α γ htpos htlen) x) :
    g ∈ spanFirstK (s + 1) hs1n := by
  sorry

/-- Main span induction: xₛ ∈ spanFirstK (s-1) for 1 ≤ s ≤ t. -/
lemma span_induction_main (α γ : ℝ) (hα : 0 < α) (hγ : 0 < γ)
    {t : ℕ} (htpos : 0 < t) (htlen : t ≤ n)
    (x g : ℕ → EuclideanSpace ℝ (Fin n))
    (hx1 : x 1 = 0)
    (hg_sub : ∀ k, g k ∈ SubderivAt (hardFun α γ htpos htlen) (x k))
    (hspan : ∀ k, x (k + 1) ∈ Submodule.span ℝ
      (Set.range (fun i : Fin k => g (i.val + 1))))
    (s : ℕ) (hs1 : 1 ≤ s) (hst : s ≤ t) :
    x s ∈ spanFirstK (s - 1) (by omega) := by
  sorry

/-- If x ∈ spanFirstK (s-1) with 1 ≤ s ≤ t, then hardFun(x) ≥ 0. -/
lemma hardFun_nonneg_of_span (α γ : ℝ) (hα : 0 < α) (hγ : 0 ≤ γ)
    {t : ℕ} (htpos : 0 < t) (htlen : t ≤ n)
    (s : ℕ) (hs : 1 ≤ s) (hst : s ≤ t)
    (x : EuclideanSpace ℝ (Fin n)) (hxspan : x ∈ spanFirstK (s - 1) (by omega)) :
    hardFun α γ htpos htlen x ≥ 0 := by
  unfold hardFun
  apply add_nonneg
  · apply mul_nonneg hγ
    -- Coordinate t-1 is zero (since t-1 ≥ s-1 and x ∈ spanFirstK (s-1))
    have hcoord_zero : x (Fin.castLE htlen ⟨t - 1, by omega⟩) = 0 := by
      have hmem := (mem_spanFirstK (s - 1) (by omega) x).mp hxspan
      apply hmem
      simp only [Fin.coe_castLE]
      omega
    -- max is ≥ the t-1 coordinate = 0
    have hmem : (⟨t - 1, by omega⟩ : Fin t) ∈ (Finset.univ : Finset (Fin t)) :=
      Finset.mem_univ _
    have hH : (Finset.univ : Finset (Fin t)).Nonempty := ⟨⟨0, htpos⟩, Finset.mem_univ _⟩
    calc 0 = x (Fin.castLE htlen ⟨t - 1, by omega⟩) := hcoord_zero.symm
      _ ≤ Finset.sup' Finset.univ hH (fun i : Fin t => x (Fin.castLE htlen i)) :=
          Finset.le_sup' (fun i : Fin t => x (Fin.castLE htlen i)) hmem
  · positivity

/-! ### Main theorem -/

/-- **Theorem 3.13** (Bubeck §3.5, strongly convex case).

For t ≤ n and L, α > 0, there exists an α-strongly convex, L-Lipschitz function
such that every first-order procedure satisfying the span oracle condition
achieves f(xₛ) − f* ≥ L²/(8αt) for all iterates 1 ≤ s ≤ t. -/
theorem theorem_3_13_sc (t : ℕ) (htpos : 0 < t) (htlen : t ≤ n)
    {L α : ℝ} (hL : 0 < L) (hα : 0 < α) :
    ∃ (f : EuclideanSpace ℝ (Fin n) → ℝ) (fstar : ℝ),
      StrongConvexOn Set.univ α f ∧
      (∀ x : EuclideanSpace ℝ (Fin n), ‖x‖ ≤ L / (2 * α) →
         ∀ g ∈ SubderivAt f x, ‖g‖ ≤ L) ∧
      ∀ (x g : ℕ → EuclideanSpace ℝ (Fin n))
        (hx1 : x 1 = 0)
        (hg_sub : ∀ k, g k ∈ SubderivAt f (x k))
        (hspan : ∀ k, x (k + 1) ∈ Submodule.span ℝ
          (Set.range (fun i : Fin k => g (i.val + 1))))
        (s : ℕ) (hs1 : 1 ≤ s) (hst : s ≤ t),
        f (x s) - fstar ≥ L ^ 2 / (8 * α * t) := by
  refine ⟨hardFun α (L/2) htpos htlen,
          hardFun α (L/2) htpos htlen (hardMin α (L/2) t htlen),
          ?hsc, ?hlip, ?hlb⟩
  · exact hardFun_stronglyConvex α (L/2) hα (by linarith) htpos htlen
  · intro x hx g hg
    exact hardFun_subgradient_bound α (L/2) L hα rfl hL htpos htlen x hx g hg
  · intro x g hx1 hg_sub hspan s hs1 hst
    have hγpos : (0 : ℝ) < L / 2 := by linarith
    -- Step 1: x s ∈ spanFirstK (s-1) by span induction
    have hxs : x s ∈ spanFirstK (s - 1) (by omega) :=
      span_induction_main α (L/2) hα hγpos htpos htlen x g hx1 hg_sub hspan s hs1 hst
    -- Step 2: f(x s) ≥ 0
    have hfxs_nn : hardFun α (L/2) htpos htlen (x s) ≥ 0 :=
      hardFun_nonneg_of_span α (L/2) hα (by linarith) htpos htlen s hs1 hst (x s) hxs
    -- Step 3: f* = -L²/(8αt)
    have hfstar : hardFun α (L/2) htpos htlen (hardMin α (L/2) t htlen) =
        -(L ^ 2 / (8 * α * t)) := by
      rw [hardFun_min_value α (L/2) hα htpos htlen]
      have ht_pos : (0 : ℝ) < t := Nat.cast_pos.mpr htpos
      field_simp; ring
    -- Step 4: conclude gap ≥ L²/(8αt)
    linarith [hfstar ▸ (sub_nonneg.mpr (hardMin_isMinimizer α (L/2) hα (by linarith) htpos htlen (x s)))]

end
