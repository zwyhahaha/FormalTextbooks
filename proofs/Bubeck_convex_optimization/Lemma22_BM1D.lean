/-
# 1D Brunn-Minkowski Inequality

For compact A, B ⊆ ℝ with positive Lebesgue measure:
  volume(A + B) ≥ volume(A) + volume(B)

Proof strategy ("separated-union trick"):
  Let a₁ = sSup A ∈ A and b₀ = sInf B ∈ B.
  Then A + {b₀} and {a₁} + B are both subsets of A + B,
  and their intersection is the singleton {a₁ + b₀} (measure zero).
  Since translating a set preserves measure:
    volume(A + B) ≥ volume((A + {b₀}) ∪ ({a₁} + B))
                   = volume(A + {b₀}) + volume({a₁} + B) - volume(intersection)
                   = volume(A) + volume(B) - 0.

Source: papers/Bubeck_convex_optimization/sections/02_01_the_center_of_gravity_method.md
-/
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Group.Measure
import Mathlib.Topology.Order.Compact
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.Algebra.Group.Pointwise.Set.Basic
import Mathlib.Topology.Algebra.Monoid

set_option linter.unusedSectionVars false
set_option maxHeartbeats 400000

open Set MeasureTheory Measure Pointwise

noncomputable section

/-- Translation of a set by adding a singleton preserves Lebesgue measure:
`volume(A + {b}) = volume(A)` for any `b : ℝ` and measurable `A`. -/
lemma measure_add_singleton (A : Set ℝ) (b : ℝ) :
    volume (A + {b}) = volume A := by
  -- A + {b} = (· + b) '' A = (· + (-b))⁻¹' A (since (· + b) is a bijection)
  -- Key: x ∈ A + {b} ↔ ∃ a ∈ A, x = a + b ↔ x - b ∈ A ↔ x + (-b) ∈ A
  have h : A + {b} = (fun x => x + (-b)) ⁻¹' A := by
    ext x
    simp only [Set.mem_add, Set.mem_singleton_iff, Set.mem_preimage]
    constructor
    · rintro ⟨a, ha, b', hb', hab'⟩
      rw [hb'] at hab'
      rwa [show x + -b = a from by linarith]
    · intro hx
      exact ⟨x + (-b), hx, b, rfl, by ring⟩
  rw [h]
  exact measure_preimage_add_right volume (-b) A

/-- Translation of a set by a singleton on the left preserves Lebesgue measure:
`volume({a} + B) = volume(B)` for any `a : ℝ` and measurable `B`. -/
lemma measure_singleton_add (B : Set ℝ) (a : ℝ) :
    volume ({a} + B) = volume B := by
  have h : {a} + B = (fun x => x + (-a)) ⁻¹' B := by
    ext x
    simp only [Set.mem_add, Set.mem_singleton_iff, Set.mem_preimage]
    constructor
    · rintro ⟨a', ha', b, hb, hab⟩
      rw [ha'] at hab
      rwa [show x + -a = b from by linarith]
    · intro hx
      exact ⟨a, rfl, x + (-a), hx, by ring⟩
  rw [h]
  exact measure_preimage_add_right volume (-a) B

/-- The intersection of `A + {b₀}` and `{a₁} + B` is contained in `{a₁ + b₀}`,
when `a₁ = sSup A` and `b₀ = sInf B`. -/
lemma inter_translate_subset_singleton
    {A B : Set ℝ}
    (hA : IsCompact A) (hB : IsCompact B) :
    (A + {sInf B}) ∩ ({sSup A} + B) ⊆ {sSup A + sInf B} := by
  intro z hz
  obtain ⟨hzL, hzR⟩ := hz
  -- z ∈ A + {sInf B}: z = a + sInf B for some a ∈ A
  simp only [Set.mem_add, Set.mem_singleton_iff] at hzL hzR
  obtain ⟨a, ha, b₀, rfl, rfl⟩ := hzL
  -- z ∈ {sSup A} + B: z = sSup A + b for some b ∈ B
  obtain ⟨a₁, rfl, b, hb, h_eq⟩ := hzR
  -- Now: a + sInf B = sSup A + b
  -- Since a ∈ A, a ≤ sSup A
  have ha_le : a ≤ sSup A := le_csSup hA.bddAbove ha
  -- Since b ∈ B, sInf B ≤ b
  have hb_ge : sInf B ≤ b := csInf_le hB.bddBelow hb
  -- a - sSup A ≤ 0 and b - sInf B ≥ 0, but a + sInf B = sSup A + b forces both = 0
  rw [Set.mem_singleton_iff]
  linarith

/-- **1D Brunn-Minkowski inequality**: For compact `A, B ⊆ ℝ` with `A.Nonempty` and
`B.Nonempty`, we have `volume(A) + volume(B) ≤ volume(A + B)`. -/
theorem brunn_minkowski_one_dim
    {A B : Set ℝ}
    (hA : IsCompact A) (hB : IsCompact B)
    (hAne : A.Nonempty) (hBne : B.Nonempty) :
    volume A + volume B ≤ volume (A + B) := by
  -- Let a₁ = sSup A, b₀ = sInf B
  set a₁ := sSup A
  set b₀ := sInf B
  -- Key subsets: A + {b₀} ⊆ A + B and {a₁} + B ⊆ A + B
  have hb₀_mem : b₀ ∈ B := hB.sInf_mem hBne
  have ha₁_mem : a₁ ∈ A := hA.sSup_mem hAne
  have hL_sub : A + {b₀} ⊆ A + B := by
    intro z ⟨a, ha, b, hb, hab⟩
    rw [Set.mem_singleton_iff] at hb
    exact ⟨a, ha, b₀, hb₀_mem, by rw [hb] at hab; exact hab⟩
  have hR_sub : {a₁} + B ⊆ A + B := by
    intro z ⟨a, ha, b, hb, hab⟩
    rw [Set.mem_singleton_iff] at ha
    exact ⟨a₁, ha₁_mem, b, hb, by rw [ha] at hab; exact hab⟩
  -- Their union is a subset of A + B
  have hU_sub : (A + {b₀}) ∪ ({a₁} + B) ⊆ A + B :=
    Set.union_subset hL_sub hR_sub
  -- Their intersection ⊆ {a₁ + b₀} (singleton, measure zero)
  have hI_sub : (A + {b₀}) ∩ ({a₁} + B) ⊆ {a₁ + b₀} :=
    inter_translate_subset_singleton hA hB
  -- Measure of the intersection is 0
  have hI_zero : volume ((A + {b₀}) ∩ ({a₁} + B)) = 0 :=
    measure_mono_null hI_sub Real.volume_singleton
  -- {a₁} + B is measurable (compact, hence measurable in a T2 space)
  have hR_meas : MeasurableSet ({a₁} + B) := by
    -- {a₁} + B is the image of B under a continuous map, hence compact, hence measurable
    have : IsCompact ({a₁} + B) := by
      have : IsCompact ({a₁} : Set ℝ) := isCompact_singleton
      exact IsCompact.add this hB
    exact this.measurableSet
  -- Translate measures: volume(A + {b₀}) = volume(A), volume({a₁} + B) = volume(B)
  have hL_vol : volume (A + {b₀}) = volume A := measure_add_singleton A b₀
  have hR_vol : volume ({a₁} + B) = volume B := measure_singleton_add B a₁
  -- Now combine:
  -- volume(A) + volume(B) = volume(A + {b₀}) + volume({a₁} + B)
  --   = volume(union) + volume(intersection)     [by measure_union_add_inter]
  --   = volume(union) + 0                        [since intersection has measure 0]
  --   = volume(union)
  --   ≤ volume(A + B)                            [since union ⊆ A + B]
  calc volume A + volume B
      = volume (A + {b₀}) + volume ({a₁} + B) := by rw [hL_vol, hR_vol]
    _ = volume ((A + {b₀}) ∪ ({a₁} + B)) + volume ((A + {b₀}) ∩ ({a₁} + B)) :=
        (measure_union_add_inter (A + {b₀}) hR_meas).symm
    _ = volume ((A + {b₀}) ∪ ({a₁} + B)) + 0 := by rw [hI_zero]
    _ = volume ((A + {b₀}) ∪ ({a₁} + B)) := by ring
    _ ≤ volume (A + B) := measure_mono hU_sub

end
